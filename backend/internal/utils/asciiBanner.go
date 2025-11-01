package utils

import "fmt"

func PrintYantraBanner() {
	banner := `
	██╗   ██╗█████╗ ███╗   ██╗████████╗██████╗  █████╗      
	╚██╗ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗     
	 ╚████╔╝ ███████║██╔██╗ ██║   ██║   ██████╔╝███████║     
	  ╚██╔╝  ██╔══██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║     
	   ██║   ██║  ██║██║ ╚████║   ██║   ██║  ██║██║  ██║     
	   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝     
	`

	colorReset := "\033[0m"
	colorMagenta := "\033[35m"
	colorBold := "\033[1m"

	fmt.Printf("%s%s%s%s\n", colorBold, colorMagenta, banner, colorReset)
}