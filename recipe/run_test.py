import subprocess
from sys import stderr

mol2_res = subprocess.run(["obabel", "-:c1ccccc1", "--gen3d", "-omol2"], capture_output=True, encoding='utf8')
mol2_success = '1 molecule converted' in mol2_res.stderr

inchi_res = subprocess.run(["obabel", "-:c1ccccc1", "-oinchi"], capture_output=True, encoding='utf8')
inchi_success = '1 molecule converted' in inchi_res.stderr
inchi_success = inchi_success and ('InChI=1S' in inchi_res.stdout)

png_res = subprocess.run(["obabel", "-:c1ccccc1", "-opng"], capture_output=True)
png_success = '1 molecule converted' in str(png_res.stderr)
png_success = png_success and (png_res.stdout[:4] == b'\x89PNG')

if not mol2_success:
    print("Failed converting SMILES to mol2 format", file=stderr)
if not inchi_success:
    print("Failed converting SMILES to InChI format", file=stderr)
if not png_success:
    print("Failed converting SMILES to png format", file=stderr)
if not(mol2_success and inchi_success and png_success):
    raise RuntimeError("Tests failed, see stderr")