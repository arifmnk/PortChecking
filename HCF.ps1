function Test-TCPPort
{
    param
    (
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [int[]]$TCPPort
    )
    foreach($C in $ComputerName)
    {
        $isPingable = Test-Connection -ComputerName $C -Count 1 -Quiet
        if($isPingable)
        {
            foreach($port in $TCPPort)
            {
                $TCPTestSucceeded = $null
                try
                {
                    $tcpClient = New-Object -TypeName System.Net.Sockets.TcpClient -ArgumentList $C, $Port
                    $TCPTestSucceeded = $tcpClient.Connected
                }
                catch
                {
                    $TCPTestSucceeded = $false
                }
                finally
                {
                    $tcpClient.Dispose()
                }

                $obj = [pscustomobject]@{
                    ComputerName = $C
                    Port = $Port
                    TCPTestSuceeded = $TCPTestSucceeded
                }
                $obj
            }
        }
        else
        {
	    #If host cannot be accessed
            #Write-Warning -Message "ComputerName '$C' is not pingable"
            $TCPTestSucceeded = 'Host Unreachable'
            $obj = [pscustomobject]@{
                    ComputerName = $C
                    Port = 'N/A'
                    TCPTestSuceeded = $TCPTestSucceeded
            }
            $obj
        }
    }    
}

$servers = (import-csv -path "Insert target path here (e.g: 'C:\serverlist.csv')").Name
Test-TCPPort -ComputerName $servers -TCPPort 80,135,445 <#|
Export-Csv -Path "Insert output path here (e.g: 'D:\HealthCheck\MainScript\HCF.csv')"ss -NoTypeInformation#>