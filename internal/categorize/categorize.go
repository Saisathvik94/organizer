package categorize


import "strings"

func GetCategory(extension string) string{
	// Map extensions to categories
	switch strings.ToLower(extension) {
	case ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".svg", ".tiff", ".ico":
		return  "Images"

	case ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".odt":
		return "Documents"

	case ".mp4", ".mkv", ".avi", ".mov", ".wmv", ".flv", ".webm":
		return "Videos"

	case ".mp3", ".wav", ".aac", ".flac", ".ogg":
		return "Audio"

	case ".zip", ".rar", ".7z", ".tar", ".gz":
		return "Archives"

	case ".py", ".c", ".cpp", ".go", ".js", ".ts", ".java", ".html", ".css", ".rb", ".php", ".rs", ".swift":
		return "Programs"

	case ".exe", ".msi", ".bat", ".sh", ".app":
		return "Executables"

	default:
		return "Others"
	}
}