package com.ruoyi.ndt.orthanc;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.ndt.config.NdtProperties;

class OrthancServiceTest
{
    @Test
    void modifyInstanceSendsPrivateCreatorForConfiguredPrivateTags()
    {
        RestClient.Builder builder = RestClient.builder();
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        OrthancService service = new OrthancService(properties(), builder);
        JSONObject tags = new JSONObject();
        tags.put("0011,0010", "RuoYiNDT");
        tags.put("0011,1012", "aaaaaaa");

        server.expect(requestTo("http://orthanc.test/instances/i-1/modify"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(content().json("{\"Replace\":{\"0011,0010\":\"RuoYiNDT\",\"0011,1012\":\"aaaaaaa\"},\"PrivateCreator\":\"RuoYiNDT\",\"Force\":true,\"KeepSource\":false}"))
                .andRespond(withSuccess(new byte[] { 1, 2, 3 }, MediaType.APPLICATION_OCTET_STREAM));

        byte[] result = service.modifyInstance("i-1", tags);

        assertArrayEquals(new byte[] { 1, 2, 3 }, result);
        server.verify();
    }

    private NdtProperties properties()
    {
        NdtProperties properties = new NdtProperties();
        properties.getOrthanc().setBaseUrl("http://orthanc.test");
        return properties;
    }
}
