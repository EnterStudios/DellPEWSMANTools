if(-not $ENV:BHProjectPath)
{
    Set-BuildEnvironment -Path $PSScriptRoot\..\..\..
}

Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) 

InModuleScope -ModuleName $ENV:BHProjectName {
    Describe 'Get-PEDRACAttribute' {

        Context  "Querying the class is successful. No filter." {
        # Arrange
            Mock -Command Get-CimInstance -MockWith {
                [pscustomobject]@{
                    'iDRAC'=$true
                }
            } -ParameterFilter {
                # param filters her
                #($filter -eq $null) -and # this fails
                [String]::IsNullOrEmpty($Filter) -and 
                ($cimsession -ne $null) -and
                ($ClassName-eq 'DCIM_iDRACCardAttribute') -and
                ($NameSpace -eq 'root\dcim')
                
            } -Verifiable

            # Act
            $Output = Get-PEDRACAttribute -iDRACSession 'dummy'

            # Assert
            It "Should query the correct class and namespace without any filter" {
                Assert-MockCalled -CommandName Get-CimInstance -Times 1 -Exactly -Scope Context
                Assert-VerifiableMocks
            }

            It "Should return the mocked object" {
                $Output | Should NOT BeNullOrEmpty
                $Output.iDRAC | Should Be $True
            }
        }

        Context 'Querying the class with filter AttributeDisplayname and GroupDisplayName' {
            # Arrange
            Mock -Command Get-CimInstance -MockWith {
                [pscustomobject]@{
                    'iDRAC'=$true
                }
            } -ParameterFilter {
                # param filters her
                #($filter -eq $null) -and # this fails
                ($Filter.Contains('AttributeDisplayName')) -and
                ($Filter.Contains('GroupDisplayName')) -and
                ($cimsession -ne $null) -and
                ($ClassName-eq 'DCIM_iDRACCardAttribute') -and
                ($NameSpace -eq 'root\dcim')
                
            } -Verifiable

            # Act
            $Output = Get-PEDRACAttribute -iDRACSession 'dummy' -AttributeDisplayName 'iDRACAttribute' -GroupDisplayName 'GroupName'

            # Assert
            It "Should query the correct class and namespace filter for AttributeDisplayName and GroupDisplayName" {
                Assert-MockCalled -CommandName Get-CimInstance -Times 1 -Exactly -Scope Context
                Assert-VerifiableMocks
            }

            It "Should return the mocked object" {
                $Output | Should NOT BeNullOrEmpty
                $Output.iDRAC | Should Be $True
            }
        }

        Context 'Querying the class with filter AttributeDisplayname' {
            # Arrange
            Mock -Command Get-CimInstance -MockWith {
                [pscustomobject]@{
                    'iDRAC'=$true
                }
            } -ParameterFilter {
                # param filters her
                #($filter -eq $null) -and # this fails
                ($Filter.Contains('AttributeDisplayName')) -and
                (-not $Filter.Contains('GroupDisplayName')) -and
                ($cimsession -ne $null) -and
                ($ClassName-eq 'DCIM_iDRACCardAttribute') -and
                ($NameSpace -eq 'root\dcim')
                
            } -Verifiable

            # Act
            $Output = Get-PEDRACAttribute -iDRACSession 'dummy' -AttributeDisplayName 'iDRACAttribute'

            # Assert
            It "Should query the correct class and namespace with filter for AttributeDisplayName" {
                Assert-MockCalled -CommandName Get-CimInstance -Times 1 -Exactly -Scope Context
                Assert-VerifiableMocks
            }

            It "Should return the mocked object" {
                $Output | Should NOT BeNullOrEmpty
                $Output.iDRAC | Should Be $True
            }
        }

        Context 'Querying the class with filter GroupDisplayname' {
            # Arrange
            Mock -Command Get-CimInstance -MockWith {
                [pscustomobject]@{
                    'iDRAC'=$true
                }
            } -ParameterFilter {
                # param filters her
                #($filter -eq $null) -and # this fails
                (-not $Filter.Contains('AttributeDisplayName')) -and
                ($Filter.Contains('GroupDisplayName')) -and
                ($cimsession -ne $null) -and
                ($ClassName-eq 'DCIM_iDRACCardAttribute') -and
                ($NameSpace -eq 'root\dcim')
                
            } -Verifiable

            # Act
            $Output = Get-PEDRACAttribute -iDRACSession 'dummy' -GroupDisplayName 'GroupName'

            # Assert
            It "Should query the correct class and namespace with filter for GroupDisplayName" {
                Assert-MockCalled -CommandName Get-CimInstance -Times 1 -Exactly -Scope Context
                Assert-VerifiableMocks
            }

            It "Should return the mocked object" {
                $Output | Should NOT BeNullOrEmpty
                $Output.iDRAC | Should Be $True
            }
        }

        Context 'Querying the class failed' {
            Mock -CommandName Get-CimInstance -MockWith { throw 'failure'} -ParameterFilter {
                ($cimsession -ne $null) -and
                ($ClassName -eq 'DCIM_iDRACCardAttribute') -and
                ($NameSpace -eq 'root\dcim')
            } -Verifiable

            $Output = Get-PEDRACAttribute -iDRACSession 'dummy' -ErrorAction SilentlyContinue -ErrorVariable PEDRACAttribError

            It "Should write the error to the error stream" {
                {Get-PEDRACAttribute -iDRACSession 'dummy' -ErrorAction Stop} | Should Throw 'failure'
                $PEDRACAttribError | Should NOT BeNullOrEmpty
                $Output | Should BeNullOrEmpty
            }

            It "Should query the correct class and namespace" {
                Assert-VerifiableMocks
            }
        }
    }
}