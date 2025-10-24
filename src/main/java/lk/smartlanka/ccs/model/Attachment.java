package lk.smartlanka.ccs.model;

public class Attachment {
    private long attachmentId;
    private long complaintId;
    private String fileName;
    private String fileType;
    private String filePath;

    // Constructors
    public Attachment() {}

    public Attachment(long attachmentId, long complaintId, String fileName, String fileType, String filePath) {
        this.attachmentId = attachmentId;
        this.complaintId = complaintId;
        this.fileName = fileName;
        this.fileType = fileType;
        this.filePath = filePath;
    }

    public long getComplaintId() { return complaintId; }
    public void setComplaintId(long complaintId) { this.complaintId = complaintId; }

}