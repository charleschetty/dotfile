#include <nvml.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  
int main() {
  nvmlReturn_t result;
  unsigned int device_count;
  char name[NVML_DEVICE_NAME_BUFFER_SIZE];

  nvmlInit();

  nvmlDevice_t device;
  result = nvmlDeviceGetHandleByIndex(0, &device);



  nvmlUtilization_t utilization = {0};
  if ((result = nvmlDeviceGetUtilizationRates(device, &utilization)) ==
      NVML_SUCCESS) {

      printf("  %3u%%     ", utilization.gpu);
      printf("󱐌 %u%%     ", utilization.memory);

  } else {
    fprintf(stderr, "  ❌ error: %s\n", nvmlErrorString(result));
  }
  nvmlMemory_t mem_info = {0};
  if ((result = nvmlDeviceGetMemoryInfo(device, &mem_info)) == NVML_SUCCESS) {
    double mem_used_gb = mem_info.used / 1024.0 / 1024.0 / 1024.0;
    double mem_total_gb = mem_info.total / 1024.0 / 1024.0 / 1024.0;
    double mem_usage_pct =
        (mem_total_gb > 0) ? (mem_used_gb / mem_total_gb * 100.0) : 0.0;
    printf("󰍛  %.1f%%     ", mem_usage_pct);
  } else {
    fprintf(stderr, "  ❌ error: %s\n", nvmlErrorString(result));
  }
  nvmlTemperature_t temp;
  memset(&temp, 0, sizeof(temp));          
  temp.version = nvmlTemperature_v1;      
  temp.sensorType = NVML_TEMPERATURE_GPU; 

  if ((result = nvmlDeviceGetTemperatureV(device, &temp)) == NVML_SUCCESS) {
    printf(" %llu °C\n", temp.temperature);
  } else {
    fprintf(stderr, "  ❌ error: %s (code: %d)\n",
            nvmlErrorString(result), result);
  }

  nvmlShutdown();
  return EXIT_SUCCESS;
}
