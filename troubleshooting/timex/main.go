package main

import (
	"fmt"

	"golang.org/x/sys/unix"
)

const (
	// The system clock is not synchronized to a reliable
	// server (TIME_ERROR).
	timeError = 5
	// The timex.Status time resolution bit (STA_NANO),
	// 0 = microsecond, 1 = nanoseconds.
	staNano = 0x2000

	// 1 second in
	nanoSeconds  = 1000000000
	microSeconds = 1000000
)

func main() {
	var timex = new(unix.Timex)

	status, err := unix.Adjtimex(timex)
	if err != nil {
		fmt.Errorf("failed to retrieve adjtimex stats: %w\n", err)
	}

  fmt.Printf("Status: %v\n", status)

	if status == timeError {
    fmt.Println("syncStatus: 0")
	} else {
    fmt.Println("syncStatus: 1")
	}
}
