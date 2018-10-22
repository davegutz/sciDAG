// Copyright (C) 2018 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Aug 25, 2018 	DA Gutz		Created
// 

// Developing print_struct that prints arrays of struct
// need to save in column form then transpose at print step
P1.a = 1;
P1.b = 2;
P1.c = 3;
P2.a = 11;
P2.b = 12;
P2.c = 13;
PS(1) = P1;
PS(2) = P2;
getd('../ControlLib'); print_struct(PS, 'PS', 6)
// work toward result that looks like:
//PS.a = 1.00000, 11.0000,
//PS.b = 2.00000, 12.0000,
//PS.c = 3.00000, 13.0000,



// Example of running servo models
//      Uses Particle Swarm Optimization
exec('myServo-PSO_run.sce');
test_run(pwd(), 'myServo-PSO_run')

// Example of running genetic algorithm
exec('example-nsga2_run.sce');

// Example of running genetic algorithm on Servoe
exec('myServo_nsga2_run.sce');

// Example of various optimzation algorithms on Rosenbrock function
exec('rosenbrock-various_run.sce');
