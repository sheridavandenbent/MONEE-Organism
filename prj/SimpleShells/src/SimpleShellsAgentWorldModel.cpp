#include "SimpleShells/include/SimpleShellsAgentWorldModel.h"

#include "World/World.h"
#include <numeric>

#include <iostream>

SimpleShellsAgentWorldModel::SimpleShellsAgentWorldModel() {
	setRobotLED_status(true);
	_action = ACTION_ACTIVATE;
	_speedPenalty = 1.0;
	_specialisation = 0.0;
	_nrBoosts = 0;
	_energyPuckId = -1;
	_energyBoost = 0.05;
	_maxNrBoosts = 10;
	_excludeEnergyPucks = true;

	// For backward compatibility, we might check gSpecialisation as bool and as double; bool false-> 0.0, true->1.0
	///bool temp(false);
	///if (gProperties.checkAndGetPropertyValue("gSpecialisation", &temp, false)) {
	///_specialisation = temp ? 1.0 : 0.0;
	///} else {

	gProperties.checkAndGetPropertyValue("gSpecialisation", &_specialisation, false);
	gProperties.checkAndGetPropertyValue("energyBoost", &_energyBoost, false);
	gProperties.checkAndGetPropertyValue("maxNrBoost", &_maxNrBoosts, false);
	gProperties.checkAndGetPropertyValue("energyPuckId", &_energyPuckId, false);
	gProperties.checkAndGetPropertyValue("excludeEnergyPucks", &_excludeEnergyPucks, false);
}

SimpleShellsAgentWorldModel::~SimpleShellsAgentWorldModel() {
}

void SimpleShellsAgentWorldModel::dumpGenePoolStats() const {
	std::vector<Genome>::const_reverse_iterator itGenome;
	double totalFitness = .0;
	gLogFile << "EggHatched: (" << gWorld->getIterations() << "; " << _xReal << "; " << _yReal << "); [";
	for (itGenome = _genePool.rbegin(); itGenome < _genePool.rend(); itGenome++) {
		if (itGenome != _genePool.rbegin()) {
			gLogFile << ", ";
		}
		gLogFile << "[";
		for (int i = 0; i < gPuckColors; i++) {
			gLogFile << itGenome->pucks[i] << ", ";
		}
		gLogFile << itGenome->fitness << ", " << itGenome->id << "]";
		totalFitness += itGenome->fitness;
	}
	gLogFile << "]; Winner: " << _winnerId << std::endl;
}

void SimpleShellsAgentWorldModel::setSpeedPenalty() {

	_speedPenalty = 1.0;
	if (_puckCounters && ! _puckCounters->empty())
	{
		double max = (double) *(std::max_element(_puckCounters->begin(), _puckCounters->end()));
		double sum = (double) std::accumulate(_puckCounters->begin(), _puckCounters->end(), 0);
		double x = (sum == 0.0) ? 1.0 : (max/sum); // x is the specialisation level

		_speedPenalty = pow(x, _specialisation);
		//        std::cout << "specialisation: " << x << " (" << max << '/' << sum << "); speed penalty: " << _speedPenalty << ", penalty level: " << _specialisation << '\n';
	}
}

void SimpleShellsAgentWorldModel::collectPuck(int g) {
	if (g == _energyPuckId) {
		if (_nrBoosts < _maxNrBoosts) {
			// add lifetime
			std::cout << "energy puck " << _nrBoosts +1 << " lifetime from " << _lifetime[PHASE_GATHERING];
			_lifetime[PHASE_GATHERING] += int(double(_lifetime[PHASE_GATHERING]) * _energyBoost);
			std::cout << " to " << _lifetime[PHASE_GATHERING] << '\n';
		}
		_nrBoosts++;
	} 

	if (g != _energyPuckId  || !_excludeEnergyPucks) {
		_puckCounters->at(g)++;
		setSpeedPenalty();
	}
}

void SimpleShellsAgentWorldModel::reset(int maxLifetime[]) {
	// Somewhat random lifetime to prevent synchronised life cycles
	_lifetime[PHASE_GATHERING] = maxLifetime[PHASE_GATHERING] * (ranf() * 0.25 + 0.75);
	_lifetime[PHASE_MATING] = maxLifetime[PHASE_MATING];

	// Remove all gathered genomes from the gene pool
	_genePool.clear();

	_puckCounters->assign(gPuckColors, 0);

	_nrBoosts = 0;
	_speedPenalty = 1.0;
}
