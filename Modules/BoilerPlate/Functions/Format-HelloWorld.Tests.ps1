$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
$format = @{
	"NullEmpty" = "Cannot validate argument on parameter '{0}'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again."
}
Describe "Format-HelloWorld" {
	Context "Given a valid name" {
		Mock Get-Date {return "05/22/2014 15:40:38"}
		$result = Format-HelloWorld -Name "Bob"
		
		It "Calls Get-Date" {
			Assert-VerifiableMocks
		}
		It "Returns expected string format" {
			$result | Should Be "Welcome to Hello World Bob on 05/22/2014 15:40:38"
		}
	}
	Context "Given a valid name is piped in" {
		Mock Get-Date {return "05/22/2014 15:40:38"}
		$result = "Bob" | Format-HelloWorld
		
		It "Calls Get-Date" {
			Assert-VerifiableMocks
		}
		It "Returns expected string format" {
			$result | Should Be "Welcome to Hello World Bob on 05/22/2014 15:40:38"
		}
	}
	Context "Given multiple valid name are piped in" {
		Mock Get-Date {return "05/22/2014 15:40:38"}
		$result = "Bob", "Betty", "Charlie", "Charles" | Format-HelloWorld
		
		It "Calls Get-Date" {
			Assert-VerifiableMocks
		}
		It "Returns expected string format" {
			$result | Should Be "Welcome to Hello World Bob on 05/22/2014 15:40:38", "Welcome to Hello World Betty on 05/22/2014 15:40:38","Welcome to Hello World Charlie on 05/22/2014 15:40:38","Welcome to Hello World Charles on 05/22/2014 15:40:38"
		}
	}
	Context "Given a null name" {
		It "Should throw an exception" {
			{Format-HelloWorld -Name $null} | Should Throw ($format.NullEmpty -f "Name")
		}
	}
	Context "Given an empty name" {
		It "Should throw an exception" {
			{Format-HelloWorld -Name ""} | Should Throw ($format.NullEmpty -f "Name")
		}
	}
}
