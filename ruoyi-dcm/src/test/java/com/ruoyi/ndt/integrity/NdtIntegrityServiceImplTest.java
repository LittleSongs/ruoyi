package com.ruoyi.ndt.integrity;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.Test;
import com.ruoyi.ndt.integrity.service.impl.NdtIntegrityServiceImpl;

class NdtIntegrityServiceImplTest
{
    @Test
    void calculatesSha256HexForOriginalFileBytes()
    {
        NdtIntegrityServiceImpl service = new NdtIntegrityServiceImpl();

        String digest = service.calculateSha256("abc".getBytes(StandardCharsets.UTF_8));

        assertEquals("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", digest);
    }
}
