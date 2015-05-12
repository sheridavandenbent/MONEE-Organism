/* Simple shells */

#ifndef SIMPLESHELLSCONFIGURATIONLOADER_H
#define	SIMPLESHELLSCONFIGURATIONLOADER_H

#include "Config/ConfigurationLoader.h"

class SimpleShellsConfigurationLoader : public ConfigurationLoader
{
	public:
		SimpleShellsConfigurationLoader();
		~SimpleShellsConfigurationLoader();

		WorldObserver *make_WorldObserver(World* wm) ;
		RobotAgentWorldModel *make_RobotAgentWorldModel();
		AgentObserver *make_AgentObserver(RobotAgentWorldModel* wm) ;
		BehaviorControlArchitecture *make_BehaviorControlArchitecture(RobotAgentWorldModel* wm) ;
		RobotAgentWorldInterface *make_RobotAgentWorldInterface() ; // interface created once in constructor, returns a pointer
};

#endif
