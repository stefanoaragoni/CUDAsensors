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
int SIZE = 16680;

// GLOBAL: funcion llamada desde el host y ejecutada en el device (kernel)
__global__ void altura( double *a, double *b, double *c, double *z)
{
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	//if(myID < z[0])
		c[myID] = a[myID] + b[myID];
	
	
}

// GLOBAL: funcion llamada desde el host y ejecutada en el device (kernel)
__global__ void temperatura( double *d, double *e, double *f, double *y)
{
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	//if(myID < y[0])
		f[myID] = d[myID] + e[myID];
	

}

__global__ void aceleracionx( double *g, double *h, double *i, double *x)
{
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	//if(myID < x[0])
		i[myID] = h[myID] + g[myID];
	
}


int main(void) 
{


	//ALMACENAR DATOS EN 3 ARRAYS. 1 TEMP, 1 ALTURA, 1 aceleracionX
	double alturaArray[SIZE], temperaturaArray[SIZE], aceleracionArray[SIZE];

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
		alturaArray[i] = 1;
		temperaturaArray[i] = 1;
		aceleracionArray[i] = 1;
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
		double *a2, *b2, *c2, *z2; // host ptrs to stream 2 arrays
		double *a3, *b3, *c3, *z3; // host ptrs to stream 2 arrays
		
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

		if(newSize%2==0){
			newSize = newSize/2;

			for(int i=0;i<newSize;i++) 
			{
				a1[i] = alturaArray[i];
				b1[i] = alturaArray[i+newSize];
				
				a2[i] = temperaturaArray[i];
				b2[i] = temperaturaArray[i+newSize];

				a3[i] = aceleracionArray[i];
				b3[i] = aceleracionArray[i+newSize];

				z1[i] = SIZE;
				z2[i] = SIZE;
				z3[i] = SIZE;
			}

		}else{
			newSize = (newSize+1)/2;

			for(int i=0;i<newSize;i++) 
			{
				a1[i] = alturaArray[i];
				a2[i] = temperaturaArray[i];
				a3[i] = aceleracionArray[i];

				z1[i] = SIZE;
				z2[i] = SIZE;
				z3[i] = SIZE;
				
				if(i == newSize-1){
					b1[i] = 0;	
					b2[i] = 0;
					b3[i] = 0;
				}
				else{
					b1[i] = alturaArray[i+newSize];
					b2[i] = temperaturaArray[i+newSize];
					b3[i] = aceleracionArray[i+newSize];
				}
				
			}
		}

		int cantHilos = 1024;
		

		if(SIZE<1024){
			cantHilos = SIZE;
		}

		int blocks = ceil(SIZE/cantHilos);
		

		//stream 1
		cudaMemcpyAsync(dev_a1,a1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_b1,b1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		cudaMemcpyAsync(dev_z1,z1,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream1);
		altura<<<blocks,cantHilos,0,stream1>>>(dev_a1,dev_b1,dev_c1,dev_z1);
		cudaMemcpyAsync(c1,dev_c1,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream1);

		//stream 2
		cudaMemcpyAsync(dev_a2,a2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_b2,b2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		cudaMemcpyAsync(dev_z2,z2,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream2);
		temperatura<<<blocks,cantHilos,0,stream2>>>(dev_a2,dev_b2,dev_c2,dev_z2);
		cudaMemcpyAsync(c2,dev_c2,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream2);

		//stream 3
		cudaMemcpyAsync(dev_a3,a3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_b3,b3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		cudaMemcpyAsync(dev_z3,z3,SIZE*sizeof(double),cudaMemcpyHostToDevice,stream3);
		aceleracionx<<<blocks,cantHilos,0,stream3>>>(dev_a3,dev_b3,dev_c3,dev_z3);
		cudaMemcpyAsync(c3,dev_c3,SIZE*sizeof(double),cudaMemcpyDeviceToHost,stream3);

		cudaStreamSynchronize(stream1); // wait for stream1 to finish
		cudaStreamSynchronize(stream2); // wait for stream2 to finish
		cudaStreamSynchronize(stream3); // wait for stream2 to finish

		for(int i = 0; i<SIZE; i++){
			alturaArray[i] = c1[i];
			temperaturaArray[i] = c2[i];
			aceleracionArray[i] = c3[i];
		}

		
		cudaStreamDestroy(stream1); 		// because we care
		cudaStreamDestroy(stream2); 
		cudaStreamDestroy(stream3); 
		
	}

	printf("\nAltura (promedio total): %f",alturaArray[0]);
	printf("\nTemperatura (promedio total): %f",temperaturaArray[0]);
	printf("\nAceleración en Eje X (promedio total): %f",aceleracionArray[0]);


	
		


	return 0;
}