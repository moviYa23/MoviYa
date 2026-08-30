const hre = require('hardhat');
require('dotenv').config();

async function main() {
  console.log('🚀 Desplegando contratos inteligentes de MoviYa...');

  // Obtener cuentas
  const [deployer] = await ethers.getSigners();
  console.log(`Desplegando desde: ${deployer.address}`);

  // 1. Desplegar MoviYangToken
  console.log('\n📝 Desplegando MoviYangToken...');
  const MoviYangToken = await hre.ethers.getContractFactory('MoviYangToken');
  const moviYangToken = await MoviYangToken.deploy();
  await moviYangToken.deployed();
  console.log(`✅ MoviYangToken desplegado en: ${moviYangToken.address}`);

  // 2. Desplegar DynamicFeeCalculator
  console.log('\n📝 Desplegando DynamicFeeCalculator...');
  const DynamicFeeCalculator = await hre.ethers.getContractFactory('DynamicFeeCalculator');
  const feeCalculator = await DynamicFeeCalculator.deploy(moviYangToken.address);
  await feeCalculator.deployed();
  console.log(`✅ DynamicFeeCalculator desplegado en: ${feeCalculator.address}`);

  // Guardar direcciones de contratos
  console.log('\n📋 Direcciones de contratos:');
  console.log(`MoviYangToken: ${moviYangToken.address}`);
  console.log(`DynamicFeeCalculator: ${feeCalculator.address}`);

  // Guardar en archivo .env.local
  const fs = require('fs');
  const envContent = `NEXT_PUBLIC_MOVIYANG_TOKEN_ADDRESS=${moviYangToken.address}
NEXT_PUBLIC_FEE_CALCULATOR_ADDRESS=${feeCalculator.address}
`;
  fs.appendFileSync('.env.local', envContent);
  console.log('\n✅ Direcciones guardadas en .env.local');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
