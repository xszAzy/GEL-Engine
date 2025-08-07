workspace "LearningEngine"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }


outputdir= "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir={}
IncludeDir["GLFW"]="LearningEngine/vendor/GLFW/include"
IncludeDir["Glad"]="LearningEngine/vendor/Glad/include"
IncludeDir["ImGui"]="LearningEngine/vendor/imgui"
IncludeDir["glm"]="LearningEngine/vendor/glm"

include "LearningEngine/vendor/GLFW"
include "LearningEngine/vendor/Glad"
include "LearningEngine/vendor/imgui"

project "LearningEngine"
    location "LearningEngine"
    kind "StaticLib"
    language "C++"
    staticruntime "on"
     cppdialect "C++17"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader"gelpch.h"
    pchsource"LearningEngine/src/gelpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/glm/glm/**.hpp",
        "%{prj.name}/vendor/glm/glm/**.inl"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
        "%{IncludeDir.glm}"
    }

    links
    {
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    filter "system:windows"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL",
             "GEL_BUILD_DLL_DEBUG",
             "GLFW_INCLUDE_NONE",
             "_CRT_SECURE_NO_WARNINGS"
         }

    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "on"

    filter "action:vs*"
            buildoptions{"/utf-8"}
            defines {"_UNICODE", "UNICODE"}





    project "Sandbox"
        location "Sandbox"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"
        staticruntime "on"

    targetdir("bin/" .. outputdir .. "/%{prj.name}")
    objdir("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "LearningEngine/vendor/spdlog/include",
        "LearningEngine/src",
        "%{IncludeDir.glm}"
    }

    links
    {
        "LearningEngine"
    }

    filter "system:windows"
         systemversion "latest"

         defines
         {
             "GEL_PLATFORM_WINDOWS",
             "GEL_BUILD_DLL"
         }


    filter "configurations:Debug"
        defines"GEL_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "GEL_RELEASE"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "GEL_DIST"
        runtime "Release"
        optimize "on"

    filter "action:vs*"
        buildoptions{"/utf-8"}
        defines {"_UNICODE", "UNICODE"}