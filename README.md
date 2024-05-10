
## Authors

- [João Paulo Paggi Zuanon Dias](https://github.com/nullifidianz)
- [Thales Clemente Pasquotto](https://github.com/thaleeews)

# Sistema de Fechadura Com senha em Assembly 8051

Este projeto consiste na implementação de uma interface de teclado matricial com um display LCD e um motor simulando uma fechadura controlado por um microcontrolador utilizando a linguagem de programação Assembly.

# Objetivo
O objetivo principal deste projeto é criar um sistema de entrada de uma senha em um microcontrolador usando um teclado matricial e exibir mensagens no display LCD de acordo com o PIN inserido com a finalidade de entender melhor a estrutura da arquitetura de computadores e da linguagem Assembly.

# Funcionalidades
- Interface de Teclado Matricial: O sistema permite que o usuário insira o PIN por meio de um teclado matricial 4x4.
- Exibição no Display LCD: As mensagens são exibidas em um display LCD de acordo com as interações do usuário. O armazenamento é realizado a partir de tabelas LUT (Lookup Tables) para facilitar a exibição de textos e afins.
- Verificação da senha: O sistema verifica se a senha inserida pelo usuário está correta.
- Feedback Visual: Fornece feedback visual ao usuário através do display LCD, indicando se o acesso foi concedido ou negado.
- Botão para alterar a senha: Após inserir a senha corretamente, o usuário pode pressionar o botão "#" para alterar o PIN da fechadura.
  
# Componentes Utilizados
- Microcontrolador 8051
- Teclado Matricial 4x4
- Display LCD

**Todos os componentes utilizados foram emulados no simulador Edsim51**


# Funcionamento

Fluxograma da lógica de Funcionamento:
[![](https://mermaid.ink/img/pako:eNp9ks9OwkAQxl-l2TOQLrRYamJiChgOGhONB9PL2A6w0e7UYUvk3wP5HL6Y61IKmOheuvP7vplpZmcjMspRxGLGUM69x-Flqj17Jlplirx2-8pLSE_VbFzprNaOwOmjD_WCQ7Uo32BVO06R89xSTiNtGHKoLSfEOe5oCQVqg7XexPseeqmAE-BDg0Ps1CdkNVUZ8HmL39h5Jwa5KbMPHN8ylmgUe2C-Pr3AW-IaF1s7h4yY0VCy_zTjOcf7Eg3deve0sJ0pqXhB_G9S8l_KGfvlt8-QYa5y-tt78kN3OIPG2qQ6242yQ7gl03Q9Aqc_YlESq3UztiNw-j0cJ-rujo5Vcf1eqZrX0UGxVLREgVyAyu32bX5cqTBzLDAVsb3mwK-pSPXO-qAy9LDSmYgNV9gSVZmDsfsFdmmLAyxBPxOdhiLeiA8R98J-5yIKBoH0ZdgPpWyJlYjbMpKdoN-PoiDodkPfv4h2LbF2FWRHRr2e74dBNxxEg6And98ZhgS6?type=png)](https://mermaid.live/edit#pako:eNp9ks9OwkAQxl-l2TOQLrRYamJiChgOGhONB9PL2A6w0e7UYUvk3wP5HL6Y61IKmOheuvP7vplpZmcjMspRxGLGUM69x-Flqj17Jlplirx2-8pLSE_VbFzprNaOwOmjD_WCQ7Uo32BVO06R89xSTiNtGHKoLSfEOe5oCQVqg7XexPseeqmAE-BDg0Ps1CdkNVUZ8HmL39h5Jwa5KbMPHN8ylmgUe2C-Pr3AW-IaF1s7h4yY0VCy_zTjOcf7Eg3deve0sJ0pqXhB_G9S8l_KGfvlt8-QYa5y-tt78kN3OIPG2qQ6242yQ7gl03Q9Aqc_YlESq3UztiNw-j0cJ-rujo5Vcf1eqZrX0UGxVLREgVyAyu32bX5cqTBzLDAVsb3mwK-pSPXO-qAy9LDSmYgNV9gSVZmDsfsFdmmLAyxBPxOdhiLeiA8R98J-5yIKBoH0ZdgPpWyJlYjbMpKdoN-PoiDodkPfv4h2LbF2FWRHRr2e74dBNxxEg6And98ZhgS6)

**A frenquência recomendada para testes é de 100hz para exibição inicial da mensagem e 10hz antes de fazer os inputs de teclado**

**Caso a frequência seja maior, ocorrerá erro de multiplas entradas no teclado matricial**
- O sistema exibe a mensagem "Entrar PIN:" no display LCD.
- O usuário insere o PIN usando o teclado matricial.
- O sistema verifica se o PIN inserido está correto.
- Se o PIN estiver correto, exibe a mensagem "Acesso Concedido" e gira o motor.
- Caso contrário, exibe a mensagem "Acesso Negado".


## Screenshots
Acesso Condedido - 

![Gif acesso_concedido](https://github.com/nullifidianz/Fechadura-Assembly/blob/main/img/acesso_concedido.gif)

Acesso Negado - 

![Gif acesso_negado](https://github.com/nullifidianz/Fechadura-Assembly/blob/main/img/acesso_negado.gif)


## Documentação Utilizada

[EdSim51's Users Guide](http://edsim51.com/simInstructions.html)

[MCS@51 MICROCONTROLLER FAMILY USER’S MANUAL](https://web.mit.edu/6.115/www/document/8051.pdf)

[Assembly para 8051 - canal WR Kits](https://www.youtube.com/@canalwrkits)
