package com.ruoyi.dcm.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withBadRequest;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.dcm.config.DcmProperties;

class DcmOrthancServiceTest
{
    @Test
    void uploadsBinaryWithoutAuthorizationWhenCredentialsAreEmpty()
    {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        DcmOrthancService service = new DcmOrthancService(properties(null, null), builder);
        byte[] content = new byte[] { 1, 2, 3 };

        server.expect(requestTo("http://orthanc.test/instances"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(request -> assertNull(request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION)))
                .andExpect(content().bytes(content))
                .andRespond(withSuccess("{\"ID\":\"instance-1\"}", MediaType.APPLICATION_JSON));

        JSONObject result = service.uploadInstance(new MockMultipartFile("file", "a.dcm", "application/dicom", content));

        assertEquals("instance-1", result.getString("ID"));
        server.verify();
    }

    @Test
    void sendsBasicAuthorizationAndReadsSimplifiedTags()
    {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        DcmOrthancService service = new DcmOrthancService(properties("reader", "secret"), builder);

        server.expect(requestTo("http://orthanc.test/instances/i-1/tags?simplify"))
                .andExpect(method(HttpMethod.GET))
                .andExpect(header(HttpHeaders.AUTHORIZATION, "Basic cmVhZGVyOnNlY3JldA=="))
                .andRespond(withSuccess("{\"StudyInstanceUID\":\"1.2.3\"}", MediaType.APPLICATION_JSON));

        JSONObject tags = service.getInstanceSimplifiedTags("i-1");

        assertEquals("1.2.3", tags.getString("StudyInstanceUID"));
        server.verify();
    }

    @Test
    void turnsOrthancHttpErrorsIntoReadableBusinessError()
    {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        DcmOrthancService service = new DcmOrthancService(properties(null, null), builder);
        server.expect(requestTo("http://orthanc.test/studies/bad"))
                .andRespond(withBadRequest());

        ServiceException exception = assertThrows(ServiceException.class, () -> service.getStudy("bad"));

        assertEquals("读取 Orthanc Study 失败，HTTP 400", exception.getMessage());
    }

    private DcmProperties properties(String username, String password)
    {
        DcmProperties properties = new DcmProperties();
        properties.getOrthanc().setBaseUrl("http://orthanc.test");
        properties.getOrthanc().setUsername(username);
        properties.getOrthanc().setPassword(password);
        return properties;
    }
}
