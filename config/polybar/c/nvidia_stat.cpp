// nvml_monitor.cpp
#include <nvml.h>

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <optional>
#include <print>


struct GpuStats {
  unsigned int gpu_util_pct{};
  unsigned int mem_util_pct{};
  double mem_used_gb{};
  double mem_total_gb{};
  double mem_usage_pct{};
  unsigned long long temperature{};
};

std::optional<nvmlDevice_t> getDeviceHandle(unsigned int index = 0) {
  nvmlDevice_t device{};
  nvmlReturn_t r = nvmlDeviceGetHandleByIndex(index, &device);
  if (r != NVML_SUCCESS) return std::nullopt;
  return device;
}

std::optional<GpuStats> queryGpuStats(nvmlDevice_t device) {
  nvmlReturn_t result;
  GpuStats stats{};

  nvmlUtilization_t util{};
  result = nvmlDeviceGetUtilizationRates(device, &util);
  if (result != NVML_SUCCESS) return std::nullopt;
  stats.gpu_util_pct = util.gpu;
  stats.mem_util_pct = util.memory;

  nvmlMemory_t meminfo{};
  result = nvmlDeviceGetMemoryInfo(device, &meminfo);
  if (result != NVML_SUCCESS) return std::nullopt;
  stats.mem_used_gb =
      static_cast<double>(meminfo.used) / 1024.0 / 1024.0 / 1024.0;
  stats.mem_total_gb =
      static_cast<double>(meminfo.total) / 1024.0 / 1024.0 / 1024.0;
  stats.mem_usage_pct = (stats.mem_total_gb > 0.0)
                            ? (stats.mem_used_gb / stats.mem_total_gb * 100.0)
                            : 0.0;

  nvmlTemperature_t temp{};
  std::memset(&temp, 0, sizeof(temp));
  temp.version = nvmlTemperature_v1;
  temp.sensorType = NVML_TEMPERATURE_GPU;
  result = nvmlDeviceGetTemperatureV(device, &temp);
  if (result != NVML_SUCCESS) return std::nullopt;
  stats.temperature = temp.temperature;

  return stats;
}

int main() {

  nvmlInit();
  auto devOpt = getDeviceHandle(0);

  nvmlDevice_t device = *devOpt;

  auto statsOpt = queryGpuStats(device);
  const GpuStats& s = *statsOpt;

  std::print("  {}%     󱐌 {}%     󰍛  {}%      {} °C\n",
             static_cast<int>(std::lround(s.gpu_util_pct)),
             static_cast<int>(std::lround(s.mem_util_pct)),
             static_cast<int>(std::lround(s.mem_usage_pct)),
             static_cast<int>(std::lround(s.temperature)));
  return EXIT_SUCCESS;
}
