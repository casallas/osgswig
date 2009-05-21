--
-- Python wrapper functions 
-- 

require 'globals'

function createPreBuildCommand(name)

	local cmd = ""
	
	local includes = ""
	
	if (target == 'vs2003' or target == 'vs2005') then
		-- only for visual studio 
		cmd = "swig -c++ -python -I..\\..\\src\\ -I\"$(OSG_ROOT)\\include\""
		
		if (name == "osgART") then
			cmd = cmd .. " -I\"$(OSGART_DIR)\\include\" -I\"$(OSGART_ROOT)\\include\""
		end
		cmd = cmd .. " -o ..\\..\\src\\Languages\\Python\\" 
			.. name .. 
			"Python.cpp ..\\..\\src\\"..name..".i\ncopy ..\\..\\src\\Languages\\Python\\" 
			.. name ..".py ..\\..\\bin\\python\ncmd";
			-- please note in the last line - cmd is been called to prevent VS to 
			-- detect the amount of warnings which are emitted from SWIG
	else
		io.write("Unsupported target system")
	end
		
	return cmd
end

function createPythonWrapper(name)
	
	-- create new package
	package = newpackage()
	package.path = project.path
	
	-- prefix is underscore and DLLs are pyd
	package.target = "_" .. name
	package.targetextension = "pyd"

	package.name = "Python " .. name
	package.language = "c++"
	package.kind = "dll"

	package.libdir = "../../lib"
	package.bindir = "../../bin/python"
	package.objdir = "obj/" .. package.target
		
	table.insert(package.prebuildcommands,createPreBuildCommand(name))
	
	table.insert(package.config['Release'].defines,"NDEBUG")

	package.defines = {
		}

	if (OS == "windows") then
		table.insert(package.defines,"WIN32")
		table.insert(package.defines,"_WINDOWS")
	end

	package.files = {
	  "../../src/Languages/Python/" .. name .. "Python.cpp",
	}

	package.includepaths = {
		"$(OSG_ROOT)/include",
		"C:\\Python24\\include",
		"C:\\Python25\\include";
	}
	
	
	package.excludes = {
			}

	package.libpaths = { "$(OSG_ROOT)/lib" }
	

	package.links = { "osg" }

	if (OS == "windows") then
		-- table.insert(package.libpaths,"C:\\Python24\\libs")
		table.insert(package.libpaths,"C:\\Python25\\libs")
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
