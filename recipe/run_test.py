import subprocess
from sys import stderr

mol2_res = subprocess.run(
    ["obabel", "-:c1ccccc1", "--gen3d", "-omol2"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    encoding="utf8",
)
mol2_success = "1 molecule converted" in mol2_res.stderr
print("mol2", mol2_res.stderr)

inchi_res = subprocess.run(
    ["obabel", "-:c1ccccc1", "-oinchi"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    encoding="utf8",
)
inchi_success = "1 molecule converted" in inchi_res.stderr
inchi_success = inchi_success and ("InChI=1S" in inchi_res.stdout)
print("inchi", inchi_res.stderr)

png_res = subprocess.run(
    ["obabel", "-:c1ccccc1", "-opng"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
png_success = "1 molecule converted" in str(png_res.stderr)
png_success = png_success and (png_res.stdout[:4] == b"\x89PNG")
print("png", png_res.stderr)

logp_res = subprocess.run(
    ["obabel", "-:c1ccccc1", "-osmi", "-xt", "--append", "logP"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    encoding="utf8",
)
logp_success = "Could not find contribution data file" not in logp_res.stderr
print("logp", logp_res.stderr)

if not mol2_success:
    print("Failed converting SMILES to mol2 format", file=stderr)
if not inchi_success:
    print("Failed converting SMILES to InChI format", file=stderr)
if not png_success:
    print("Failed converting SMILES to png format", file=stderr)
if not logp_success:
    print("Failed to find data files", file=stderr)
if not (mol2_success and inchi_success and png_success and logp_success):
    raise RuntimeError("Tests failed, see stderr")
