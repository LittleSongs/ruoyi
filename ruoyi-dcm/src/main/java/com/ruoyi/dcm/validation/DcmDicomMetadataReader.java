package com.ruoyi.dcm.validation;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import org.springframework.stereotype.Component;
import com.ruoyi.common.exception.ServiceException;

/**
 * Lightweight DICOM metadata reader for upload validation.
 */
@Component
public class DcmDicomMetadataReader
{
    private static final String IMPLICIT_LITTLE_ENDIAN = "1.2.840.10008.1.2";
    private static final String EXPLICIT_BIG_ENDIAN = "1.2.840.10008.1.2.2";

    public DcmDicomMetadata read(Path path)
    {
        try
        {
            byte[] data = Files.readAllBytes(path);
            if (data.length < 132 || data[128] != 'D' || data[129] != 'I' || data[130] != 'C' || data[131] != 'M')
            {
                throw new ServiceException("不是有效的 DICOM Part 10 文件");
            }
            DcmDicomMetadata metadata = new DcmDicomMetadata();
            int offset = parseElements(data, 132, metadata, true, false, true);
            String transferSyntax = metadata.getTransferSyntaxUid();
            boolean explicitVr = !IMPLICIT_LITTLE_ENDIAN.equals(transferSyntax);
            boolean bigEndian = EXPLICIT_BIG_ENDIAN.equals(transferSyntax);
            parseElements(data, offset, metadata, explicitVr, bigEndian, false);
            return metadata;
        }
        catch (IOException e)
        {
            throw new ServiceException("读取 DICOM 文件失败：" + e.getMessage());
        }
    }

    private int parseElements(byte[] data, int offset, DcmDicomMetadata metadata, boolean explicitVr,
            boolean bigEndian, boolean metaOnly)
    {
        while (offset + 8 <= data.length)
        {
            int group = ushort(data, offset, bigEndian);
            int element = ushort(data, offset + 2, bigEndian);
            if (metaOnly && group != 0x0002)
            {
                return offset;
            }
            String tagCode = String.format("%04X%04X", group, element);
            if ("7FE00010".equals(tagCode))
            {
                return offset;
            }

            ElementHeader header = readHeader(data, offset, explicitVr, bigEndian);
            if (header.length < 0 || header.valueOffset + header.length > data.length)
            {
                return header.valueOffset;
            }
            String value = value(data, header.valueOffset, header.length);
            apply(metadata, tagCode, value);
            offset = header.valueOffset + header.length;
        }
        return offset;
    }

    private ElementHeader readHeader(byte[] data, int offset, boolean explicitVr, boolean bigEndian)
    {
        if (!explicitVr)
        {
            return new ElementHeader(offset + 8, uint(data, offset + 4, bigEndian));
        }
        String vr = new String(data, offset + 4, 2, StandardCharsets.US_ASCII);
        if ("OB".equals(vr) || "OD".equals(vr) || "OF".equals(vr) || "OL".equals(vr)
                || "OW".equals(vr) || "SQ".equals(vr) || "UC".equals(vr) || "UR".equals(vr)
                || "UT".equals(vr) || "UN".equals(vr))
        {
            return new ElementHeader(offset + 12, uint(data, offset + 8, bigEndian));
        }
        return new ElementHeader(offset + 8, ushort(data, offset + 6, bigEndian));
    }

    private void apply(DcmDicomMetadata metadata, String tagCode, String value)
    {
        metadata.putTagValue(tagCode, value);
        switch (tagCode)
        {
            case "00020002" -> metadata.setMediaStorageSopClassUid(value);
            case "00020010" -> metadata.setTransferSyntaxUid(value);
            case "00080016" -> metadata.setSopClassUid(value);
            case "00080018" -> metadata.setSopInstanceUid(value);
            case "00080060" -> metadata.setModality(value);
            case "0020000D" -> metadata.setStudyInstanceUid(value);
            case "0020000E" -> metadata.setSeriesInstanceUid(value);
            default -> { }
        }
    }

    private String value(byte[] data, int offset, int length)
    {
        if (length <= 0)
        {
            return "";
        }
        int end = offset + length;
        while (end > offset && (data[end - 1] == 0 || data[end - 1] == ' '))
        {
            end--;
        }
        return new String(data, offset, end - offset, StandardCharsets.UTF_8).trim();
    }

    private int ushort(byte[] data, int offset, boolean bigEndian)
    {
        if (bigEndian)
        {
            return ((data[offset] & 0xff) << 8) | (data[offset + 1] & 0xff);
        }
        return (data[offset] & 0xff) | ((data[offset + 1] & 0xff) << 8);
    }

    private int uint(byte[] data, int offset, boolean bigEndian)
    {
        long value;
        if (bigEndian)
        {
            value = ((long) (data[offset] & 0xff) << 24) | ((long) (data[offset + 1] & 0xff) << 16)
                    | ((long) (data[offset + 2] & 0xff) << 8) | (long) (data[offset + 3] & 0xff);
        }
        else
        {
            value = (long) (data[offset] & 0xff) | ((long) (data[offset + 1] & 0xff) << 8)
                    | ((long) (data[offset + 2] & 0xff) << 16) | ((long) (data[offset + 3] & 0xff) << 24);
        }
        return value == 0xffffffffL ? -1 : (int) value;
    }

    private static class ElementHeader
    {
        private final int valueOffset;
        private final int length;

        private ElementHeader(int valueOffset, int length)
        {
            this.valueOffset = valueOffset;
            this.length = length;
        }
    }
}
