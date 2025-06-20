# Blockchain-Based Energy Grid Load Balancing

A comprehensive blockchain solution for managing energy grid load balancing, operator verification, demand response programs, and grid stability maintenance using Clarity smart contracts.

## Overview

This system provides a decentralized approach to energy grid management with the following key features:

- **Grid Operator Verification**: Secure registration and verification of energy grid operators
- **Load Monitoring**: Real-time monitoring and tracking of grid load patterns
- **Balancing Coordination**: Automated coordination of load balancing operations
- **Demand Response**: Management of demand response programs with participant incentives
- **Stability Maintenance**: Continuous monitoring and automated responses for grid stability

## Architecture

The system consists of five interconnected smart contracts:

### 1. Grid Operator Verification (`grid-operator-verification.clar`)
- Manages operator registration and verification
- Tracks operator permissions and capabilities
- Ensures only verified operators can perform critical operations

### 2. Load Monitoring (`load-monitoring.clar`)
- Monitors real-time grid load patterns
- Tracks load history and identifies critical conditions
- Provides load status categorization (low, normal, high, critical)

### 3. Balancing Coordination (`balancing-coordination.clar`)
- Coordinates load balancing actions across regions
- Manages generation adjustments and load shedding
- Tracks capacity constraints and emergency responses

### 4. Demand Response (`demand-response.clar`)
- Creates and manages demand response programs
- Handles participant registration and reward distribution
- Supports multiple program types (peak shaving, load shifting, emergency response)

### 5. Stability Maintenance (`stability-maintenance.clar`)
- Monitors grid stability metrics (frequency, voltage, phase angle)
- Triggers automated responses to stability issues
- Manages emergency mode and critical event resolution

## Key Features

### Security
- Multi-level authorization system
- Operator verification requirements
- Emergency mode protections

### Automation
- Automated stability responses
- Load balancing coordination
- Real-time monitoring and alerting

### Incentives
- Reward system for demand response participation
- Performance-based operator permissions
- Transparent reward distribution

### Scalability
- Regional load management
- Distributed operator network
- Flexible program configuration

## Smart Contract Functions

### Grid Operator Verification
\`\`\`clarity
(register-operator name region capacity)
(verify-operator operator)
(get-operator operator)
(is-verified-operator operator)
\`\`\`

### Load Monitoring
\`\`\`clarity
(report-load region capacity-mw demand-mw)
(get-current-load region)
(is-critical-load region)
(get-load-status load-percentage)
\`\`\`

### Balancing Coordination
\`\`\`clarity
(initiate-balancing-action region action-type target-mw priority)
(complete-balancing-action action-id)
(set-region-capacity region max-generation current-generation reserve-capacity)
\`\`\`

### Demand Response
\`\`\`clarity
(create-demand-program name program-type region target-reduction-mw incentive-rate duration-blocks)
(join-program program-id committed-reduction-mw)
(report-reduction program-id participant actual-reduction-mw)
\`\`\`

### Stability Maintenance
\`\`\`clarity
(report-stability-metrics region frequency voltage phase-angle)
(trigger-stability-response region frequency voltage severity)
(configure-automated-response trigger-condition action-type target-adjustment priority)
\`\`\`

## Installation

1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts to Stacks blockchain

## Testing

The system includes comprehensive test suites using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract functionality
- Error handling
- Authorization checks
- Data validation
- Integration scenarios

## Usage Examples

### Register as Grid Operator
\`\`\`clarity
(contract-call? .grid-operator-verification register-operator "PowerCorp" "North" u1000)
\`\`\`

### Report Load Data
\`\`\`clarity
(contract-call? .load-monitoring report-load "North" u1000 u750)
\`\`\`

### Create Demand Response Program
\`\`\`clarity
(contract-call? .demand-response create-demand-program "Peak Shaving" u1 "North" u200 u10 u1000)
\`\`\`

### Report Stability Metrics
\`\`\`clarity
(contract-call? .stability-maintenance report-stability-metrics "North" u5000 u100 u0)
\`\`\`

## Configuration

### Load Thresholds
- Low: ≤30%
- Normal: 31-79%
- High: 80-94%
- Critical: ≥95%

### Stability Thresholds
- Frequency: 49.5-50.5 Hz
- Voltage: 95-105% of nominal
- Response levels: Normal, Alert, Emergency, Critical

### Program Types
1. Peak Shaving
2. Load Shifting
3. Emergency Response

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For technical support or questions, please open an issue in the repository.
\`\`\`

Finally, let's create the PR details file:
