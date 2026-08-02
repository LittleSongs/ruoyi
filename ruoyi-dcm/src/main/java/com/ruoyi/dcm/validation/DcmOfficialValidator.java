package com.ruoyi.dcm.validation;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
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
        Process process = null;
        try
        {
            process = builder.start();
            // Drain stdout/stderr on separate threads so a full pipe buffer can never
            // block the child process from finishing (classic ProcessBuilder deadlock).
            CompletableFuture<String> stdout = readAsync(process.getInputStream());
            CompletableFuture<String> stderr = readAsync(process.getErrorStream());
            boolean finished = process.waitFor(
                    Duration.ofSeconds(validation.getOfficialTimeoutSeconds()).toMillis(), TimeUnit.MILLISECONDS);
            if (!finished)
            {
                process.destroyForcibly();
                process.waitFor(5, TimeUnit.SECONDS);
                result.setStatus("FAIL");
                result.setExitCode(-1);
                result.setStdout(join(stdout));
                result.setStderr("validate_iods timed out after " + validation.getOfficialTimeoutSeconds()
                        + "s；已终止进程。" + join(stderr));
                return result;
            }
            int exitCode = process.exitValue();
            result.setStatus(exitCode == 0 ? "PASS" : "FAIL");
            result.setExitCode(exitCode);
            result.setStdout(join(stdout));
            result.setStderr(join(stderr));
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
            if (process != null)
            {
                process.destroyForcibly();
            }
            result.setStatus("FAIL");
            result.setExitCode(-1);
            result.setStdout("");
            result.setStderr("validate_iods interrupted");
            return result;
        }
    }

    private CompletableFuture<String> readAsync(InputStream stream)
    {
        return CompletableFuture.supplyAsync(() ->
        {
            try (InputStream in = stream)
            {
                return new String(in.readAllBytes(), StandardCharsets.UTF_8);
            }
            catch (IOException ex)
            {
                return "";
            }
        });
    }

    private String join(CompletableFuture<String> future)
    {
        try
        {
            return future.get(5, TimeUnit.SECONDS);
        }
        catch (InterruptedException ex)
        {
            Thread.currentThread().interrupt();
            return "";
        }
        catch (ExecutionException | java.util.concurrent.TimeoutException ex)
        {
            return "";
        }
    }
}
