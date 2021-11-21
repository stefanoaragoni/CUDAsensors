/**
 * --------------------------------------------------------
 * Universidad del Valle de Guatemala
 * CC3056 - Programación de Microprocesadores
 * --------------------------------------------------------
 * --------------------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
//#include <json-c/json.h>

#define INICIAL = 16680;
#define INICIAL2 = 5560;
int SIZE = 16680;
int SIZE2 = 5560;

// GLOBAL: funcion llamada desde el host y ejecutada en el device (kernel)
__global__ void suma( double *a, double *b, double *c, double *z)
{
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	//if(myID < z[0])
		c[myID] = a[myID] + b[myID];

}


int main(void) 
{

	//ALMACENAR DATOS EN 3 ARRAYS. 1 TEMP, 1 ALTURA, 1 aceleracionX
	double alturaArray[SIZE], temperaturaArray[SIZE], aceleracionArray[SIZE];

	double alturaArrayONE[SIZE2], alturaArrayTWO[SIZE2], alturaArrayTHREE[SIZE2];
	double temperaturaArrayONE[SIZE2], temperaturaArrayTWO[SIZE2], temperaturaArrayTHREE[SIZE2];
	double aceleracionArrayONE[SIZE2], aceleracionArrayTWO[SIZE2], aceleracionArrayTHREE[SIZE2];

	/*FILE *fp;
    int num = 1024;
    char buffer[num];

    struct json_object *parsed_json
    struct json_object *AcelerometroX
    struct json_object *temperaturaAmbiente
    struct json_object *altitude

	size_t ArSize;
	

    fp = fopen("StefanoLuis.json","r");
    fread(buffer, num,1,fp);
    fclose(fp);

    parsed_json = json_tokener_parse(buffer);

    json_object_object_get_ex(parsed_json, "AcelerometroX", &AcelerometroX)
    json_object_object_get_ex(parsed_json, "temperaturaAmbiente", &temperaturaAmbiente)
    json_object_object_get_ex(parsed_json, "altitude", &altitude)

	ArSize = json_object_array_length(altitude);

	for(size_t i=0;i<ArSize;i++) {
		double AcelTemp = json_object_get_double(json_object_array_get_idx(AcelerometroX, i));
		double TempTemp = json_object_get_double(json_object_array_get_idx(temperaturaAmbiente, i));
		double AltTemp = json_object_get_double(json_object_array_get_idx(altitude, i));

		alturaArray[i] = AltTemp;
		temperaturaArray[i] = TempTemp;
		aceleracionArray[i] = TempTemp
	}	*/

	for(int i=0;i<SIZE;i++) {
		alturaArray[i] = 9;
		temperaturaArray[i] = 9;
		aceleracionArray[i] = 9;

	}

	for(int i=0;i<SIZE2;i++) {
		alturaArrayONE[i] = 3;
		alturaArrayTWO[i] = 3;
		alturaArrayTHREE[i] = 3;
	 	
		temperaturaArrayONE[i] = 3;
		temperaturaArrayTWO[i] = 3;
		temperaturaArrayTHREE[i] = 3;

		aceleracionArrayONE[i] = 3;
		aceleracionArrayTWO[i] = 3;
		aceleracionArrayTHREE[i] = 3;

	}

	//WHILE HASTA QUE EL LARGO DE CADA ARRAY SEA 1
	while (SIZE > 1){

		//3 STREAMS. CADA STREAM SE ENCARGARÁ DE 1 VARIABLE
		//--- Stream management ---
		//Object creation
		cudaStream_t stream1, stream2, stream3;
		//Stream initialization
		cudaStreamCreate(&stream1);
		cudaStreamCreate(&stream2);
		cudaStreamCreate(&stream3);

		double *a1, *b1, *c1, *z1; // host ptrs to stream 1 arrays
		double *a2, *b2, *c2, *z2; 
		double *a3, *b3, *c3, *z3; 
		
		double *dev_a1, *dev_b1, *dev_c1, *dev_z1; // stream 1 mem ptrs
		double *dev_a2, *dev_b2, *dev_c2, *dev_z2; // stream 2 mem ptrs
		double *dev_a3, *dev_b3, *dev_c3, *dev_z3; // stream 2 mem ptrs


		int newSize = SIZE+1;
		newSize = newSize-1;

		if(newSize%2==0){
			SIZE = SIZE/2;
		}if(newSize%2!=0){
			SIZE = (SIZE+1)/2;
		}
		
		//stream 1 - mem allocation at Global memmory for device and host
		//---- allocation for device, then host memories required for pinned allocation
		cudaMalloc( (void**)&dev_a1, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_b1, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_c1, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_z1, SIZE * sizeof(double) );
		
		cudaHostAlloc((void**)&a1,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b1,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c1,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z1,SIZE*sizeof(double),cudaHostAllocDefault);
		
		//stream 2 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a2, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_b2, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_c2, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_z2, SIZE* sizeof(double) );
		
		cudaHostAlloc((void**)&a2,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b2,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c2,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z2,SIZE*sizeof(double),cudaHostAllocDefault);

		//stream 3 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a3, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_b3, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_c3, SIZE * sizeof(double) );
		cudaMalloc( (void**)&dev_z3, SIZE* sizeof(double) );
		
		cudaHostAlloc((void**)&a3,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b3,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c3,SIZE*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z3,SIZE*sizeof(double),cudaHostAllocDefault);


		for(int i=0;i<SIZE;i++) 
		{
			a1[i] = alturaArray[i];
			b1[i] = alturaArray[i+SIZE];
			
			a2[i] = temperaturaArray[i];
			b2[i] = temperaturaArray[i+SIZE];

			a3[i] = aceleracionArray[i];
			b3[i] = aceleracionArray[i+SIZE];

			z1[i] = SIZE;
			z2[i] = SIZE;
			z3[i] = SIZE;
		}


		newSize = newSize + 1;

		if(newSize%2==0){
			b1[SIZE-1] = 0;

			b2[SIZE-1] = 0;

			b3[SIZE-1] = 0;
		}

		/*printf("\n");
		for(int loop = 0; loop < SIZE; loop++)
      		printf("%f ", a1[loop]);
		printf("\n\t");
		for(int loop = 0; loop < SIZE; loop++)
      		printf("%f ", b1[loop]);*/


		int cantHilos = 1024;
		
		if(SIZE<1024){
			cantHilos = SIZE;
		}

		int blocks = (SIZE/cantHilos)+1;	

		//stream 1
		cudaMemcpyAsync(dev_a1,a1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_b1,b1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_z1,z1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		suma<<<blocks,cantHilos,0,stream1>>>(dev_a1,dev_b1,dev_c1,dev_z1);
		cudaMemcpyAsync(c1,dev_c1,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream1);

		//stream 2
		cudaMemcpyAsync(dev_a2,a2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_b2,b2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_z2,z2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		suma<<<blocks,cantHilos,0,stream2>>>(dev_a2,dev_b2,dev_c2,dev_z2);
		cudaMemcpyAsync(c2,dev_c2,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream2);

		//stream 3
		cudaMemcpyAsync(dev_a3,a3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_b3,b3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_z3,z3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		suma<<<blocks,cantHilos,0,stream3>>>(dev_a3,dev_b3,dev_c3,dev_z3);
		cudaMemcpyAsync(c3,dev_c3,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream3);

		cudaStreamSynchronize(stream1); // wait for stream1 to finish
		cudaStreamSynchronize(stream2); // wait for stream2 to finish
		cudaStreamSynchronize(stream3); // wait for stream2 to finish

		for(int i = 0; i<SIZE; i++){
			alturaArray[i] = c1[i];
			temperaturaArray[i] = c2[i];
			aceleracionArray[i] = c3[i];
		}

		//printf("\n\t POST SIZE: %d, A1 %f, B1 %f",SIZE, c1[0], c1[SIZE-1]);
		
		cudaStreamDestroy(stream1); 		// because we care
		cudaStreamDestroy(stream2); 
		cudaStreamDestroy(stream3); 
		
	}

	printf("\nAltura (promedio total): %f",alturaArray[0]/16680);
	printf("\nTemperatura (promedio total): %f",temperaturaArray[0]/16680);
	printf("\nAceleración en Eje X (promedio total): %f",aceleracionArray[0]/16680);


	//WHILE HASTA QUE EL LARGO DE CADA ARRAY SEA 1
	while (SIZE2 > 1){

		//3 STREAMS. CADA STREAM SE ENCARGARÁ DE 1 VARIABLE
		//--- Stream management ---
		//Object creation
		cudaStream_t stream1, stream2, stream3, stream4, stream5, stream6, stream7, stream8, stream9;
		//Stream initialization
		cudaStreamCreate(&stream1);
		cudaStreamCreate(&stream2);
		cudaStreamCreate(&stream3);
		cudaStreamCreate(&stream4);
		cudaStreamCreate(&stream5);
		cudaStreamCreate(&stream6);
		cudaStreamCreate(&stream7);
		cudaStreamCreate(&stream8);
		cudaStreamCreate(&stream9);


		double *a1, *b1, *c1, *z1; // host ptrs to stream 1 arrays
		double *a2, *b2, *c2, *z2; 
		double *a3, *b3, *c3, *z3; 
		double *a4, *b4, *c4, *z4; 
		double *a5, *b5, *c5, *z5; 
		double *a6, *b6, *c6, *z6; 
		double *a7, *b7, *c7, *z7; 
		double *a8, *b8, *c8, *z8; 
		double *a9, *b9, *c9, *z9; 

		
		double *dev_a1, *dev_b1, *dev_c1, *dev_z1; // stream 1 mem ptrs
		double *dev_a2, *dev_b2, *dev_c2, *dev_z2; // stream 2 mem ptrs
		double *dev_a3, *dev_b3, *dev_c3, *dev_z3; 
		double *dev_a4, *dev_b4, *dev_c4, *dev_z4; 
		double *dev_a5, *dev_b5, *dev_c5, *dev_z5; 
		double *dev_a6, *dev_b6, *dev_c6, *dev_z6; 
		double *dev_a7, *dev_b7, *dev_c7, *dev_z7; 
		double *dev_a8, *dev_b8, *dev_c8, *dev_z8; 
		double *dev_a9, *dev_b9, *dev_c9, *dev_z9; 


		int newSIZE2 = SIZE2+1;
		newSIZE2 = newSIZE2-1;

		if(newSIZE2%2==0){
			SIZE2 = SIZE2/2;
		}if(newSIZE2%2!=0){
			SIZE2 = (SIZE2+1)/2;
		}
		
		//stream 1 - mem allocation at Global memmory for device and host
		//---- allocation for device, then host memories required for pinned allocation
		cudaMalloc( (void**)&dev_a1, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b1, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c1, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z1, SIZE2 * sizeof(double) );
		
		cudaHostAlloc((void**)&a1,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b1,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c1,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z1,SIZE2*sizeof(double),cudaHostAllocDefault);
		
		//stream 2 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a2, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b2, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c2, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z2, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a2,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b2,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c2,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z2,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 3 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a3, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b3, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c3, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z3, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a3,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b3,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c3,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z3,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 4 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a4, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b4, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c4, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z4, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a4,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b4,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c4,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z4,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 5 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a5, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b5, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c5, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z5, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a5,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b5,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c5,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z5,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 6 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a6, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b6, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c6, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z6, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a6,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b6,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c6,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z6,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 7 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a7, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b7, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c7, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z7, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a7,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b7,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c7,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z7,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 8 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a8, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b8, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c8, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z8, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a8,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b8,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c8,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z8,SIZE2*sizeof(double),cudaHostAllocDefault);

		//stream 9 - mem allocation at Global memmory for device and host, in order
		cudaMalloc( (void**)&dev_a9, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_b9, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_c9, SIZE2 * sizeof(double) );
		cudaMalloc( (void**)&dev_z9, SIZE2* sizeof(double) );
		
		cudaHostAlloc((void**)&a9,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&b9,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&c9,SIZE2*sizeof(double),cudaHostAllocDefault);
		cudaHostAlloc((void**)&z9,SIZE2*sizeof(double),cudaHostAllocDefault);

		for(int i=0;i<SIZE2;i++) 
		{
			a1[i] = alturaArrayONE[i];
			b1[i] = alturaArrayONE[i+SIZE2];
			a2[i] = alturaArrayTWO[i];
			b2[i] = alturaArrayTWO[i+SIZE2];
			a3[i] = alturaArrayTHREE[i];
			b3[i] = alturaArrayTHREE[i+SIZE2];

			a4[i] = temperaturaArrayONE[i];
			b4[i] = temperaturaArrayONE[i+SIZE2];
			a5[i] = temperaturaArrayTWO[i];
			b5[i] = temperaturaArrayTWO[i+SIZE2];
			a6[i] = temperaturaArrayTHREE[i];
			b6[i] = temperaturaArrayTHREE[i+SIZE2];

			a7[i] = aceleracionArrayONE[i];
			b7[i] = aceleracionArrayONE[i+SIZE2];
			a8[i] = aceleracionArrayTWO[i];
			b8[i] = aceleracionArrayTWO[i+SIZE2];
			a9[i] = aceleracionArrayTHREE[i];
			b9[i] = aceleracionArrayTHREE[i+SIZE2];

			z1[i] = SIZE2;
			z2[i] = SIZE2;
			z3[i] = SIZE2;
			z4[i] = SIZE2;
			z5[i] = SIZE2;
			z6[i] = SIZE2;
			z7[i] = SIZE2;
			z8[i] = SIZE2;
			z9[i] = SIZE2;
		}

		newSIZE2 = newSIZE2 + 1;

		if(newSIZE2%2==0){
			b1[SIZE2-1] = 0;
			b2[SIZE2-1] = 0;
			b3[SIZE2-1] = 0;

			b4[SIZE2-1] = 0;
			b5[SIZE2-1] = 0;
			b6[SIZE2-1] = 0;

			b7[SIZE2-1] = 0;
			b8[SIZE2-1] = 0;
			b9[SIZE2-1] = 0;
		}

		int cantHilos = 1024;
		
		if(SIZE2<1024){
			cantHilos = SIZE2;
		}

		int blocks = (SIZE2/cantHilos)+1;	

		//stream 1
		cudaMemcpyAsync(dev_a1,a1,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_b1,b1,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_z1,z1,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream1);
		suma<<<blocks,cantHilos,0,stream1>>>(dev_a1,dev_b1,dev_c1,dev_z1);
		cudaMemcpyAsync(c1,dev_c1,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream1);

		//stream 2
		cudaMemcpyAsync(dev_a2,a2,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_b2,b2,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_z2,z2,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream2);
		suma<<<blocks,cantHilos,0,stream2>>>(dev_a2,dev_b2,dev_c2,dev_z2);
		cudaMemcpyAsync(c2,dev_c2,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream2);

		//stream 3
		cudaMemcpyAsync(dev_a3,a3,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_b3,b3,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_z3,z3,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream3);
		suma<<<blocks,cantHilos,0,stream3>>>(dev_a3,dev_b3,dev_c3,dev_z3);
		cudaMemcpyAsync(c3,dev_c3,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream3);

		//stream 4
		cudaMemcpyAsync(dev_a4,a4,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream4);
		cudaMemcpyAsync(dev_b4,b4,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream4);
		cudaMemcpyAsync(dev_z4,z4,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream4);
		suma<<<blocks,cantHilos,0,stream4>>>(dev_a4,dev_b4,dev_c4,dev_z4);
		cudaMemcpyAsync(c4,dev_c4,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream4);

		//stream 5
		cudaMemcpyAsync(dev_a5,a5,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream5);
		cudaMemcpyAsync(dev_b5,b5,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream5);
		cudaMemcpyAsync(dev_z5,z5,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream5);
		suma<<<blocks,cantHilos,0,stream5>>>(dev_a5,dev_b5,dev_c5,dev_z5);
		cudaMemcpyAsync(c5,dev_c5,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream5);

		//stream 6
		cudaMemcpyAsync(dev_a6,a6,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream6);
		cudaMemcpyAsync(dev_b6,b6,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream6);
		cudaMemcpyAsync(dev_z6,z6,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream6);
		suma<<<blocks,cantHilos,0,stream6>>>(dev_a6,dev_b6,dev_c6,dev_z6);
		cudaMemcpyAsync(c6,dev_c6,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream6);

		//stream 7
		cudaMemcpyAsync(dev_a7,a7,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream7);
		cudaMemcpyAsync(dev_b7,b7,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream7);
		cudaMemcpyAsync(dev_z7,z7,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream7);
		suma<<<blocks,cantHilos,0,stream7>>>(dev_a7,dev_b7,dev_c7,dev_z7);
		cudaMemcpyAsync(c7,dev_c7,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream7);

		//stream 8
		cudaMemcpyAsync(dev_a8,a8,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream8);
		cudaMemcpyAsync(dev_b8,b8,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream8);
		cudaMemcpyAsync(dev_z8,z8,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream8);
		suma<<<blocks,cantHilos,0,stream8>>>(dev_a8,dev_b8,dev_c8,dev_z8);
		cudaMemcpyAsync(c8,dev_c8,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream8);

		//stream 9
		cudaMemcpyAsync(dev_a9,a9,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream9);
		cudaMemcpyAsync(dev_b9,b9,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream9);
		cudaMemcpyAsync(dev_z9,z9,SIZE2*sizeof(double),cudaMemcpyHostToDevice,stream9);
		suma<<<blocks,cantHilos,0,stream9>>>(dev_a9,dev_b9,dev_c9,dev_z9);
		cudaMemcpyAsync(c9,dev_c9,SIZE2*sizeof(double),cudaMemcpyDeviceToHost,stream9);

		cudaStreamSynchronize(stream1); // wait for stream1 to finish
		cudaStreamSynchronize(stream2); // wait for stream2 to finish
		cudaStreamSynchronize(stream3);
		cudaStreamSynchronize(stream4);
		cudaStreamSynchronize(stream5);
		cudaStreamSynchronize(stream6);
		cudaStreamSynchronize(stream7);
		cudaStreamSynchronize(stream8);
		cudaStreamSynchronize(stream9);

		for(int i = 0; i<SIZE2; i++){
			alturaArrayONE[i] = c1[i];
			alturaArrayTWO[i] = c2[i];
			alturaArrayTHREE[i] = c3[i];
			
			temperaturaArrayONE[i] = c4[i];
			temperaturaArrayTWO[i] = c5[i];
			temperaturaArrayTHREE[i] = c6[i];

			aceleracionArrayONE[i] = c7[i];
			aceleracionArrayTWO[i] = c8[i];
			aceleracionArrayTHREE[i] = c9[i];
		}

		cudaStreamDestroy(stream1); 		// because we care
		cudaStreamDestroy(stream2); 
		cudaStreamDestroy(stream3); 
		cudaStreamDestroy(stream4); 
		cudaStreamDestroy(stream5); 
		cudaStreamDestroy(stream6); 
		cudaStreamDestroy(stream7); 
		cudaStreamDestroy(stream8);
		cudaStreamDestroy(stream9);  
		
	}

	printf("\n\nAltura (promedio DIA 1): %f",alturaArrayONE[0]/5560);
	printf("\nAltura (promedio DIA 2): %f",alturaArrayTWO[0]/5560);
	printf("\nAltura (promedio DIA 3): %f",alturaArrayTHREE[0]/5560);

	printf("\n\nTemperatura (promedio DIA 1): %f",temperaturaArrayONE[0]/5560);
	printf("\nTemperatura (promedio DIA 2): %f",temperaturaArrayTWO[0]/5560);
	printf("\nTemperatura (promedio DIA 3): %f",temperaturaArrayTHREE[0]/5560);

	printf("\n\nAceleración en Eje X (promedio DIA 1): %f",aceleracionArrayONE[0]/5560);
	printf("\nAceleración en Eje X (promedio DIA 2): %f",aceleracionArrayTWO[0]/5560);
	printf("\nAceleración en Eje X (promedio DIA 3): %f",aceleracionArrayTHREE[0]/5560);

	printf("\n\n\nStefano Aragoni, Luis Santos. \n~ se utilizaron 12 streams~.\n");


	return 0;
}