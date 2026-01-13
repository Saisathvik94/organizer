package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/Saisathvik94/organizer/internal/organizer"
)


func main() {
	// HELP Flag
	flag.Usage = func() {
		fmt.Println("Organizer CLI")
		fmt.Println()
		fmt.Println("Description:")
		fmt.Println("  Organizes files into folders based on file type.")
		fmt.Println()
		fmt.Println("Usage:")
		fmt.Println("  organizer <path>")
		fmt.Println()
		fmt.Println("Flags:")
		fmt.Printf("-h, --help	")
		fmt.Println("help for organizer")
		fmt.Printf("--dry-run	")
		fmt.Println("dry run before organizing files")
		
	}

	dryRun := flag.Bool("dry-run", false, "Show what would happen without moving files")

	flag.Parse()
	args := flag.Args()

	if len(args) < 1 {
		flag.Usage()
		return
	}

	err := organizer.Run(args[0], *dryRun)
	if err!=nil{
		log.Fatal(err)
	}
}