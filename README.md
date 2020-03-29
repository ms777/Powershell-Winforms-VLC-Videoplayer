# Powershell Winforms VLC Videoplayer

This is a demo how to include a VLC video player into a Winform launched by Powershell.
The below dlls are required to be in your lib path, and the plugins folder from the videolan nupkg:
```
plugins                                                                                        
libvlc.dll                                                                                     
libvlccore.dll                                                                                 
LibVLCSharp.dll                                                                                
LibVLCSharp.WinForms.dll                                                                       
Microsoft.Threading.Tasks.dll                                                                  
Microsoft.Threading.Tasks.Extensions.Desktop.dll                                               
Microsoft.Threading.Tasks.Extensions.dll   
```
You can obtain them by obtaining the below NuGet packages, unzipping them, and selecting the right dll wir your platform (x86 or x64)
```
libvlcsharp.3.4.3.nupkg                                                                        
libvlcsharp.forms.3.4.3.nupkg                                                                  
libvlcsharp.winforms.3.4.3.nupkg                                                               
microsoft.bcl.async.1.0.168.nupkg                                                              
videolan.libvlc.windows.3.0.8.1.nupkg   
```

Tested on Win10 only. This is just a proof of concept and a help in identifying the required nupkg/dlls.   
