# Build Optimization and CPU Fix

## Fixed Issues

### 1. Docker CPU Allocation Error ✅
**Problem**: `Error response from daemon: range of CPUs is from 0.01 to 1.00, as there are only 1 CPUs available`

**Root Cause**: The `nmc-storybook` service was configured to request 2 CPUs but the system only had 1 CPU available.

**Solution**: 
- Reduced CPU limits from 2 to 1 CPU
- Reduced CPU reservations from 1 to 0.5 CPU
- Made the configuration compatible with single-CPU systems

**Before**:
```yaml
deploy:
  resources:
    limits:
      cpus: '2'  # ❌ Too high for single CPU systems
    reservations:
      cpus: '1'  # ❌ Reserved entire CPU
```

**After**:
```yaml
deploy:
  resources:
    limits:
      cpus: '1'    # ✅ Compatible with single CPU
    reservations:
      cpus: '0.5'  # ✅ Reasonable reservation
```

### 2. Build Time Optimization 🚀

**Problem**: Build time was ~15 minutes

**Solutions Implemented**:

#### A. BuildKit Optimization
- Enabled Docker BuildKit for all builds
- Added inline cache configuration
- Implemented multi-stage caching

#### B. Resource Management
- Added CPU and memory limits appropriate for single-CPU systems
- Optimized parallel builds vs sequential builds
- Created development-specific optimizations

#### C. Fast Build Script
Created `scripts/fast-build.sh` with:
- Automatic resource detection
- Optimized build order
- Cache management
- Parallel vs sequential build fallback

#### D. Environment Configuration
- `.env.build` file with optimized settings
- `docker-compose.dev.yml` for development
- Proper cache directories and settings

## How to Use Optimizations

### For Production
```bash
# Use optimized build script
./scripts/fast-build.sh

# Or use docker-compose with optimizations
DOCKER_BUILDKIT=1 docker compose build --parallel
```

### For Development
```bash
# Use development configuration with caching
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build

# Or use the development build mode
./scripts/fast-build.sh dev
```

### Build Information
```bash
# Check current build configuration
./scripts/fast-build.sh info

# Clean build cache
./scripts/fast-build.sh clean
```

## Performance Improvements

| Optimization | Expected Improvement |
|--------------|---------------------|
| CPU Fix | 🔥 Fixes build failures on single-CPU systems |
| BuildKit | ⚡ 30-50% faster builds through better caching |
| Parallel Builds | ⚡ 20-40% faster builds on multi-CPU systems |
| Cache Management | ⚡ 60-80% faster subsequent builds |
| Resource Limits | 🧠 Better memory management, fewer OOM errors |

## System Compatibility

| System Type | CPU Limit | Memory Limit | Build Mode |
|------------|-----------|--------------|------------|
| Single CPU | 1 core | 4GB | Sequential |
| Dual CPU | 1.5 cores | 6GB | Limited Parallel |
| Quad CPU+ | 2+ cores | 8GB+ | Full Parallel |

## Monitoring Build Performance

```bash
# Check system resources before build
./scripts/fast-build.sh info

# Monitor build process
docker system df
docker stats

# Check build cache usage
docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}"
```

## Troubleshooting

### If builds still fail with CPU errors:
1. Check available CPUs: `nproc`
2. Check Docker limits: `docker info | grep CPUs`
3. Use sequential builds: `docker compose build --no-parallel`

### If builds are still slow:
1. Clean Docker cache: `./scripts/fast-build.sh clean`
2. Use development configuration: `./scripts/fast-build.sh dev`
3. Check network connectivity for dependency downloads

### For very limited systems:
```bash
# Use minimal resource configuration
docker compose -f docker-compose.yml -f docker-compose.dev.yml build --no-parallel
```

## Files Modified

- `docker-compose.yml` - Fixed CPU limits and added caching
- `docker-compose.dev.yml` - Development optimizations
- `.env.build` - Build environment configuration
- `scripts/fast-build.sh` - Optimized build script
- `README.md` - Updated documentation

## Verification

The fixes can be verified by:
1. ✅ No CPU allocation errors during `docker compose up`
2. ✅ Build process starts successfully 
3. ✅ Resource limits within system capabilities
4. ✅ Faster subsequent builds due to caching

The main issue was the CPU configuration mismatch - this has been resolved and the project should now build successfully on single-CPU systems.