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

// Run all tests
test_run(pwd())

// Example of running servo model
//      Uses Particle Swarm Optimization
exec('allServo-PSO_run.sce');
//test_run(pwd(), 'allServo-PSO_run')


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
