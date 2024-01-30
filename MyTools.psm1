<#
.Synopsis
This function will make a lab.
.Description
This tool helps you to make your Hyper-V lab.before using that you should have a os that pre installed in the parent vhdx.
this tool just has -Differencing parameter to make vhdx and user can not change that param.  
.Example
make-lab -vhpath D:\Hyper-V\VHDs -vhdxparentpath E:\Hyper-V\VHDXs\parent.vhdx -vmnumber 5 -vmname machine -startupmemorybytes 5gb -vmpath D:\Hyper-V\VMs -gen 2 -Verbose
#>
function Make-lab {
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]

param(
    #vhdx part
     [parameter(HelpMessage='type number of vhdx that you want',
     ValueFromPipeline=$true)]
     [Alias('vhnum')]
     [int]$vmnumber=10,

     [parameter(Mandatory=$true,HelpMessage='where do you want to store yor vhdxes',
     ValueFromPipeline=$true)]
     $vhpath,

     [parameter(Mandatory=$true,HelpMessage='type the path of your premaked parent vhdx',
     ValueFromPipeline=$true)]
     [Alias('vhparent','mainvh')]
    # [ValidateScript({Get-Item $vhdxparentpath})]
     $vhdxparentpath,
     #vm part
     [parameter(Mandatory=$true,HelpMessage='define the name of your vm name',
     ValueFromPipeline=$true)]
     [Alias('namevm','vm')]
     [string]$vmname,

     [parameter(Mandatory=$true,HelpMessage='dedicate how much sturtup memory do you want assign to your machine',
     ValueFromPipeline=$true)]
     [Alias('Ram','memory')]
     [System.Int64]$startupmemorybytes,

     [parameter(Mandatory=$false,HelpMessage='dedicate a vswitch that is created',
     ValueFromPipeline=$true)]
     [Alias('switch')]
     [string]$switchname="default switch",

     [parameter(Mandatory=$true,HelpMessage='where do you want store your VMs',
     ValueFromPipeline=$true)]
     [Alias('vmlocation')]
     [ValidateScript({test-path $_})]
     $vmpath,

     [parameter(Mandatory=$true,HelpMessage='which generation',
     ValueFromPipeline=$true)]
     [ValidateSet('1','2')]
     [int]$gen,

     [parameter(Mandatory=$false,HelpMessage='virtual hard disk filename')]
     [string]$vh='vh',

     [parameter(Mandatory=$false,HelpMessage='if use this flag a logfile will be created on D:\Documents\scripts\lab-creator\ ')]
     [switch]$errlog


    )


        begin{

        if($PSCmdlet.ShouldProcess("creats a file path and its own logfile on that")){
        #default logging location

        if(-not(Test-Path 'D:\Documents\scripts\lab-creator')){
                    
                    mkdir D:\Documents\scripts\lab-creator -Force
                    New-Item -Name logfile -Path D:\Documents\scripts\lab-creator\logfile -ItemType "file" -Force}
        
        $logloc = "D:\Documents\scripts\lab-creator\logfile"
        }
    
            if($PSCmdlet.ShouldProcess("Making $vmnumber Virtual Machine Up")){
           
                for($p=1;$p -le $vmnumber;$p++)
                {
                try{
                 $newvh=New-VHD -Differencing -Path $($vhpath +'\'+ $vh + $p + '.vhdx')  -ParentPath $vhdxparentpath -ErrorAction SilentlyContinue -ErrorVariable erripo
                 Write-Output $newvh
                 New-VM -Name $($vmname + $p) -MemoryStartupBytes $startupmemorybytes -SwitchName $switchname -VHDPath $newvh.Path -Generation $gen -Path $($vmpath + '\')
                Write-Verbose "vhdx depends on $($newvh.ParentPath)"
                Write-Verbose "vhd format = $($newvh.VhdFormat) with $($newvh.VhdFormat) format created on $($newvh.ComputerName)"
                Write-Verbose "vhdx stored on $($newvh.Path)"
                }catch{Write-Warning "the path does not exist"}
                 
                                }}
                 
                                
             }
                
                

        
        
        
        process{
                
                if($errlog){
                '---------------------------------------------------'| Out-File $logloc -Append
                get-date| Out-File $logloc -ErrorAction Ignore -Append 
                $erripo | Out-File $logloc -ErrorAction Ignore -Append 
                
                }
        
            
            }
            end{}


                        }
                    