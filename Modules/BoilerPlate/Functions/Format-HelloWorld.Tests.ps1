$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

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
	Context "Given a null name" {
		It "Should throw an exception" {
			{Format-HelloWorld -Name $null} | Should Throw "Cannot validate argument on parameter 'Name'. The argument is null or empty. Supply an argument that is not null or empty and then try the command again."
		}
	}
	Context "Given an empty name" {
		It "Should throw an exception" {
			{Format-HelloWorld -Name ""} | Should Throw "Cannot validate argument on parameter 'Name'. The argument is null or empty. Supply an argument that is not null or empty and then try the command again."
		}
	}
}
