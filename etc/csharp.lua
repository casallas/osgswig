--
-- C# wrapper functions 
-- 

require 'globals'

function createPreBuildCommand(name)

	local cmd = ""
	
	local includes = ""
	
	if (target == 'vs2003' or target == 'vs2005') then
		-- only for visual studio 
		cmd = "swig -c++ -csharp -dllimport _".. name .." -nodefaultdtor -I..\\..\\src\\ -I&quot;$(OSG_ROOT)\\include&quot; -outdir &quot;..\\..\\src\\Language\\C#\\" .. name .. "&quot;"
		
		if (name == "osgART") then
			cmd = cmd .. " -I&quot;$(OSGART_DIR)\\include&quot; -I&quot;$(OSGART_ROOT)\\include&quot;"
		end
		cmd = cmd .. " -o ..\\..\\src\\Languages\\C#\\" 
			.. name .. 
			"CS.cpp ..\\..\\src\\"..name..".i\ncmd";
			-- please note in the last line - cmd is been called to prevent VS to 
			-- detect the amount of warnings which are emitted from SWIG
	else
		io.write("Unsupported target system")
	end
		
	return cmd
end


function createCSWrapperWrapper(name)

	-- create new package
	package = newpackage()
	package.path = project.path
	
	-- prefix is underscore and DLLs are pyd
	package.target = name
	package.targetextension = "dll"

	package.name = "C# Assembly " .. name
	package.language = "c#"
	package.kind = "dll"
	
	package.files = {
	  "../../src/Languages/C#/" .. name .. "PINVOKE.cs",
	}

end

function createCSWrapper(name)

	createCSWrapperWrapper(name)
	
	-- create new package
	package = newpackage()
	package.path = project.path
	
	-- prefix is underscore and DLLs are pyd
	package.target = "_" .. name
	package.targetextension = "dll"

	package.name = "C# " .. name
	package.language = "c++"
	package.kind = "dll"

	package.libdir = "../../lib"
	package.bindir = "../../bin/csharp"
	package.objdir = "obj/" .. package.target
		
	table.insert(package.prebuildcommands,createPreBuildCommand(name))
	
	table.insert(package.config['Release'].defines,"NDEBUG")

	package.defines = {
		}

	if (OS == "windows") then
		table.insert(package.defines,"WIN32")
		table.insert(package.defines,"_WINDOWS")
		table.insert(package.defines,"NT=1")
	end

	package.files = {
	  "../../src/Languages/C#/" .. name .. "CS.cpp",
	  "../../src/" .. name .. ".i"
	}

	package.includepaths = {
		"$(OSG_ROOT)/include",
	}
	
	
	package.excludes = {
			}

	package.libpaths = { "$(OSG_ROOT)/lib" }
	

	package.links = { "osg" }

	if (OS == "windows") then

		table.insert(package.libpaths,"$(OSG_ROOT)\\lib")
		table.insert(package.links, { "OpenGL32", "OpenThreads" })

	end
	
	if (name == "osgART") then
		table.insert(package.includepaths,"$(OSGART_DIR)/include")
		table.insert(package.libpaths,"$(OSGART_DIR)/lib")
	end
	

	table.insert(package.links,name)

	package.config["Debug"].target = package.target .. globals.targetsuffix
	
	return package

end
