#!/bin/bash
export OMPI_MCA_plm=isolated
export OMPI_MCA_rmaps_base_oversubscribe=yes
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# customize.py example found at: https://gitlab.com/gpaw/gpaw/blob/master/customize.py
cat <<EOF>customize.py
compiler = '${CC}'
mpicompiler = 'mpicc'  # use None if you don't want to build a gpaw-python
mpilinker = 'mpicc'
scalapack = True
fftw = True
libraries += ['scalapack', 'fftw3']
              #'scalapack-openmpi',
              #'blacsCinit-openmpi',
              #'blacs-openmpi']
define_macros += [('GPAW_NO_UNDERSCORE_CBLACS', '1')]
define_macros += [('GPAW_NO_UNDERSCORE_CSCALAPACK', '1')]
extra_link_args += ['-Wl,-rpath=$PREIFX/lib']

if 'xc' not in libraries:
    libraries.append('xc')

EOF

python -m pip install . --no-deps -vv
# gpaw install-data --no-register $PREFIX/share

mkdir -p "$PREFIX/etc/conda/activate.d"
mkdir -p "$PREFIX/etc/conda/deactivate.d"
cp "$RECIPE_DIR/activate.sh" "$PREFIX/etc/conda/activate.d/gpaw-activate.sh"
cp "$RECIPE_DIR/deactivate.sh" "$PREFIX/etc/conda/deactivate.d/gpaw-deactivate.sh"
