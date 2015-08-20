#ifndef SIMPLESHELLSAGENTWORLDMODEL_H
#define SIMPLESHELLSAGENTWORLDMODEL_H

#include "RoboroboMain/common.h"
#include "RoboroboMain/roborobo.h"

#include "WorldModels/RobotAgentWorldModel.h"

class World;

enum {PHASE_GATHERING, PHASE_MATING};
enum {ACTION_ACTIVATE, ACTION_GATHER, ACTION_BRAKE, ACTION_MATE, ACTION_SELECT, ACTION_SIZE};

class SimpleShellsAgentWorldModel : public RobotAgentWorldModel {
	public:
        std::vector<int>* _puckCounters;
        std::vector<Genome> _genePool;

        int _lifetime[2];
        int _phase;
        int _action;
        double _speedPenalty;   /// < Speed multiplication factor between 0 and 1 (1: no penalty)
        double _specialisation; /// < Speed penalty exponent, set through config file
        int _energyPuckId;      /// < Id of puck type that gives energy, this can be disregarded as a task (defaults to -1, set through config file)
        bool _fixedBoost;    /// < If true, energy boost is a percentage of original lifetime, otherwise (the default) a percentage of remaining lifetime
        bool _excludeEnergyPucks; /// < If true, pucks of type _energyPuckId are disregarded as a task, if false, energy pucks also count as task (defaults to true)
        double _energyBoost;     /// < Percentage to add to lifetime when picking up an energy puck. Default 5, set through config file
        int _maxNrBoosts;		/// < Maximum number of lifetime boosts. Default 10, set through config file.
        int _nrBoosts;		    /// < Number of lifetime boosts experienced.
        
        Uint32 _winnerId;

		SimpleShellsAgentWorldModel();
		virtual ~SimpleShellsAgentWorldModel();

        inline int lifetime() {
            return _lifetime[_phase];
        }

        inline void nextAction() {
            _action = (_action + 1) % ACTION_SIZE;
        }

        inline int advance() {
            if (((_action == ACTION_GATHER) || (_action == ACTION_MATE)) && (--_lifetime[_phase] > 0)) return _lifetime[_phase];
            _action = (_action + 1) % ACTION_SIZE;
            return 0;
        }

        void dumpGenePoolStats() const;
    
        /// Determines the speed penalty due to gathering multiple types of puck. Called whenever a puck is collected.
        void setSpeedPenalty();

        /// Reacts to a collision with a puck of type g. Updates counts, adds energy, etc.
        void collectPuck(int g);

        /// Clears WM information to start a new life.
        void reset(int maxLifetime[]);

	private:
        double _maxLifetime; /// < The original maximum lifetime as determined in reset()

};


#endif
