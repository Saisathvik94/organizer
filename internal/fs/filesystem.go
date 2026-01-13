package fs

import (
	"os"
	"path/filepath"
)

func CheckPathExist(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func NormalizePath(path string) (string, error) {
	cleaned := filepath.Clean(path)
	return filepath.Abs(cleaned)
}

func CollectFiles(path string) ([]string, string, error) {
	info, err := os.Stat(path)
	if err != nil {
		return nil, "", err
	}

	var files []string
	parentDir := path

	if info.IsDir() {
		entries, err := os.ReadDir(path)
		if err != nil {
			return nil, "", err
		}
		for _, e := range entries {
			if !e.IsDir() {
				files = append(files, filepath.Join(path, e.Name()))
			}
		}
	} else {
		parentDir = filepath.Dir(path)
		files = append(files, path)
	}

	return files, parentDir, nil
}
