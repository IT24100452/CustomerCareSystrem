package lk.smartlanka.ccs.infra;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileStorage {
  private static final String UPLOAD_DIR = "/uploads/";

  public static String saveAttachment(HttpServletRequest request, long complaintId) throws Exception {
    String appPath = request.getServletContext().getRealPath("");
    String savePath = appPath + UPLOAD_DIR + complaintId;
    File fileSaveDir = new File(savePath);
    if (!fileSaveDir.exists()) {
      fileSaveDir.mkdirs();
    }

    // Try to find a file part (support common field names)
    Part filePart = getFirstFilePart(request);
    if (filePart == null || filePart.getSize() == 0) {
      return null;
    }

    String submitted = filePart.getSubmittedFileName();
    if (submitted == null || submitted.isEmpty()) {
      return null;
    }
    String fileName = Paths.get(submitted).getFileName().toString();
    Path target = Paths.get(savePath, fileName);

    try (InputStream in = filePart.getInputStream(); FileOutputStream out = new FileOutputStream(target.toFile())) {
      in.transferTo(out);
    }
    return UPLOAD_DIR + complaintId + "/" + fileName;
  }

  private static Part getFirstFilePart(HttpServletRequest request) {
    try {
      for (Part part : request.getParts()) {
        String fileName = part.getSubmittedFileName();
        if (fileName != null && part.getSize() > 0) {
          return part;
        }
      }
    } catch (Exception ignored) {
    }
    return null;
  }
}