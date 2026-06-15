package com.ruoyi.dcm.validation;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.dcm.config.DcmProperties;

@Component
public class DcmOfficialValidator
{
    @Autowired
    private DcmProperties properties;

    public DcmOfficialValidationResult validate(Path dicomPath)
    {
        DcmProperties.Validation validation = properties.getValidation();
        DcmOfficialValidationResult result = new DcmOfficialValidationResult();
        if (!validation.isOfficialEnabled())
        {
            result.setStatus("PASS");
            result.setExitCode(0);
            result.setStdout("validate_iods disabled by configuration");
            result.setStderr("");
            return result;
        }
        List<String> command = new ArrayList<>(Arrays.asList(validation.getOfficialCommand().split("\\s+")));
        command.add(dicomPath.toString());
        ProcessBuilder builder = new ProcessBuilder(command);
        try
        {
            Process process = builder.start();
            boolean finished = process.waitFor(Duration.ofSeconds(validation.getOfficialTimeoutSeconds()).toMillis(), TimeUnit.MILLISECONDS);
            if (!finished)
            {
                process.destroyForcibly();
                result.setStatus("FAIL");
                result.setExitCode(-1);
                result.setStdout("");
                result.setStderr("validate_iods timed out");
                return result;
            }
            int exitCode = process.exitValue();
            result.setStatus(exitCode == 0 ? "PASS" : "FAIL");
            result.setExitCode(exitCode);
            result.setStdout(new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8));
            result.setStderr(new String(process.getErrorStream().readAllBytes(), StandardCharsets.UTF_8));
            return result;
        }
        catch (IOException e)
        {
            result.setStatus("FAIL");
            result.setExitCode(-1);
            result.setStdout("");
            result.setStderr("validate_iods failed to start: " + e.getMessage());
            return result;
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            result.setStatus("FAIL");
            result.setExitCode(-1);
            result.setStdout("");
            result.setStderr("validate_iods interrupted");
            return result;
        }
    }
}
