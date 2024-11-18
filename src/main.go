package main

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"
)

func getSystem() (string, string, string) {
	var os string = runtime.GOOS
	var arch string = runtime.GOARCH
	var systemOs string = "undefined"
	var systemDistro string = "undefined"
	var systemCpu string = "undefined"
	var systemPkgManager string = "undefined"

	switch os {
	case "darwin":
		systemOs = "osx"
	case "linux":
		systemOs = "linux"
	case "windows":
		systemOs = "windows"
	default:
		systemOs = "unknown"
	}

	switch arch {
	case "arm64":
		systemCpu = "arm64"
	case "amd64":
		systemCpu = "x86"
	}

	switch {
	case systemOs == "osx" && systemCpu == "arm64":
		systemPkgManager = "homebrew_silicon"
	case systemOs == "osx" && systemCpu == "amd64":
		systemPkgManager = "homebrew_intel"
	case systemOs == "linux" && systemDistro == "Fedora":
		systemPkgManager = "dnf"
	case systemOs == "linux" && systemDistro == "Debian":
		systemPkgManager = "apt"
	}

	return systemOs, systemCpu, systemPkgManager
}

func installExecutable(execName string) {
	_, _, systemPkgManager := getSystem()
	var installCmd *exec.Cmd

	switch systemPkgManager {
	case "homebrew_silicon":
		installCmd = exec.Command("brew", "install", execName)
	case "homebrew_intel":
		installCmd = exec.Command("brew", "install", execName)
	case "dnf":
		installCmd = exec.Command("sudo", "dnf", "install", "-y", execName)
	case "apt":
		installCmd = exec.Command("sudo", "apt", "install", "-y", execName)
	default:
		fmt.Printf("Unknown Package Manager: %s\n", systemPkgManager)
		return
	}
	// error handling
	installCmd.Stdout = os.Stdout
	installCmd.Stderr = os.Stderr
	err := installCmd.Run()
	if err != nil {
		fmt.Printf("failed to install %s: %v\n", execName, err)
	} else {
		fmt.Printf("installation successful %s\n", execName)
	}
}

func ensureExecutables(executables []string) {
	for _, execName := range executables {
		_, err := exec.LookPath(execName)
		if err != nil {
			fmt.Printf("Executable %s not found in $PATH. Installing..\n", execName)
			installExecutable(execName)
		}
	}
}

func main() {
	if len(os.Args) >= 1 { // only run when there are 1 or more executables passed
		executables := os.Args[1:]
		ensureExecutables(executables)
	} else {
		return
	}
}
