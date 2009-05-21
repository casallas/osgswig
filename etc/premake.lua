-- 
-- 
-- 

require 'globals'
require 'python'
-- require 'csharp'


globals.init()

--
-- osg - Python
--
project.name = "osgBindings"
project.configs = { "Debug", "Release" }

if     (target == "vs2003") then
	project.path = "../VisualStudio/VS2003"
elseif (target == "vs2005") then
	project.path = "../VisualStudio/VS2005"
end

package = createPythonWrapper("osg")
package = createPythonWrapper("osgDB")
package = createPythonWrapper("osgUtil")
package = createPythonWrapper("osgGA")
package = createPythonWrapper("osgFX")
package = createPythonWrapper("osgShadow")
package = createPythonWrapper("osgSim")
package = createPythonWrapper("osgTerrain")
package = createPythonWrapper("osgText")
package = createPythonWrapper("osgParticle")
package = createPythonWrapper("osgManipulator")
package = createPythonWrapper("osgViewer")
package = createPythonWrapper("osgVRPN")

table.insert(package.links,{"osgGA"})

--[[
table.insert(package.links,{"osg"})
table.insert(package.links,{"osgDB"})
table.insert(package.links,{"osgUtil"})

package = createPythonWrapper("osgVRPN")
table.insert(package.links,{"osgGA"})
--]]
package = createPythonWrapper("osgART")

-- Producer (deprecated!)
-- package = createPythonWrapper("osgProducer")
-- table.insert(package.links,{"Producer", "osgGA"})



-- createCSWrapper("osg")
-- createCSWrapper("osgViewer")
-- table.insert(package.links,{"osgGA"})

