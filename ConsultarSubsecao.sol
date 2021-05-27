//SPDX-Licence-Identifier: NOME
//Contrato inicialmente criado por Claudio Girao Barreto e editado por Jeff Prestes

pragma solidity 0.8.4;

contract ConsultarSusecao{
    
    mapping(string=>string) public competencia;

    mapping(uint=>string) public regioes;

    constructor() {
        regioes[1] = "DF";
        regioes[2] = "RJ e ES";
        regioes[3] = "SP e MS";
        regioes[4] = "PR, SC e RS";
        regioes[5] = "PE, AL, PB, RN e CE";
    }

    function incluirMunicipionaSubsecao (string memory _municipio, string memory _subsecao) public{
        competencia[_municipio] = _subsecao;
    }

    function consultarSubsecao (string memory _municipio) public view returns (string memory){
        return competencia[_municipio];
    }
}
