Definimos a nossa ISA tentando manter uma estrutura que seja semelhante entre todas as funções disponíveis (como o OPCODE ser sempre os 3 primeiros bits). Como só existem 8 registos disponíveis, definimos cada endereço de registo com o tamanho de 3-bits, aproveitando ao máximo todos os bits disponíveis numa arquitetura de 16-bits, aumentando, assim, o tamanho do IMM. Segue apresentada a ISA utilizada:

li   --> OPCODE [15-13] - 000 | RD [12-10] |       IMM [9-0]
add  --> OPCODE [15-13] - 100 | RD [12-10] |       RS1 [9-7]
dot  --> OPCODE [15-13] - 101 | RD [12-10] | 	   RS1 [9-7]
dota --> OPCODE [15-13] - 110 | RD [12-10] | RS1 [9-7] | RS2 [6-4]

Criamos um circuito simples, tentando dividir certos procedimentos em subcircuitos individuais, como o PC e o BancoRegistos, uma vez que vão sempre funcionar da mesma forma, criando assim um nível de abstração aquando da visualização do ficheiro principal. Além destes, criámos também mais três módulos, que visam a facilitação da leitura, análise e divisão procedimental, são estes a ALU, DotA e Dot. A nossa ALU apenas executa uma soma entre dois inputs, uma vez que modularizamos o Dot e DotA, dada a complexidade dos mesmos ser muito elevada.

As unidades funcionais calculam os seus resultados em paralelo, sendo selecionado no final, através de um MUX, apenas o resultado correspondente ao OPCODE da instrução atual.

PC ------------ Program Counter - Seleciona a próxima instrução a ser executada;
BancoRegistos - Recebe endereços e tem como output todos os valores necessários para cada operação;
DotA ---------- Executa a operação -- RD + (RS1 * RS2) + ((RS1+1) * (RS2+1));
Dot ----------- Executa a operação -- (RD * RS1) + ((RD+1) * (RS1+1));
ALU ----------- Executa uma operação entre dois inputs.

Decidimos manter esta ALU inserida no programa visando possível extensibilidade da arquitetura. Se, por exemplo, quiséssemos adicionar uma função simples de subtração ou de comparação, com ou sem imediato, seria, assim, possível a inserção da mesma, designando um OPCODE que selecionasse os inputs corretos nos MUX's (0xx - com imediato, 1xx - sem imediato). Teríamos adicionar um novo input na ALU que filtrasse a operação a ser executada (como um ALUSrc, estudado em aula, e.g. o próprio OPCODE). O MUX final encontra-se apenas metade ocupado, facilitando assim, também a extensão da lista de instruções disponíveis para execução.

Modularizamos o nosso projeto o máximo possível, por ser um processador em single-cycle. Isto obrigou a que todos os operandos necessários à execução de cada instrução fossem lidos e disponibilizados num ciclo. Optámos não colocar o OPCODE, como filtro, para apenas nos devolver os valores necessários, porque aumentaria imenso a complexidade geral do programa, contrário ao nosso objetivo.

Seguem exemplos de cada função: ('-' indica que tanto pode ser 0 como 1)
li R2, 245 ------> 0000 1000 1111 0101 ou 0x08f5
add R6, R3 ------> 1001 1001 1--- ---- ou 0x9980 (por exemplo)
dot R4, R2 ------> 1011 0001 0--- ---- ou 0xb100 (por exemplo)
dota R2, R5, R7 -> 1100 1010 1111 ---- ou 0xcaf0 (por exemplo)