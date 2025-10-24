package lk.smartlanka.ccs.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String relPath = req.getParameter("path");
        if (relPath == null || relPath.contains("..")) {
            resp.sendError(400);
            return;
        }

        String base = req.getServletContext().getRealPath("") + "/uploads/";
        Path resolved = Paths.get(base).resolve(relPath).normalize();
        if (!resolved.startsWith(Paths.get(base))) {
            resp.sendError(403);
            return;
        }

        File file = resolved.toFile();
        if (file.exists()) {
            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
            try (FileInputStream in = new FileInputStream(file); OutputStream out = resp.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int length;
                while ((length = in.read(buffer)) > 0) {
                    out.write(buffer, 0, length);
                }
            }
        } else {
            resp.sendError(404);
        }
    }
}