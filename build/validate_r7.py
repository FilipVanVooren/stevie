"""Run the native search, keyboard/color and BASIC regression suites for R7."""
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
logs = root / 'build/autorepeat/validation-r7'
logs.mkdir(parents=True, exist_ok=True)
source = Path(sys.argv[1]) if len(sys.argv) > 1 else None
jobs = []
scenarios = {
    'mixed-empty': ['--mixed', '--empty-basic'],
    'mixed-program': ['--mixed'],
    'mixed-auto': ['--mixed', '--auto'],
    'mixed-dismiss': ['--mixed', '--dismiss'],
    'cycle-empty': ['--cycle', '--empty-basic'],
    'resume-empty': ['--resume', '--empty-basic'],
}
for mode in (2480, 3080, 4880, 6080):
    jobs.append((f'keyboard-{mode}', ['node', 'build/test_autorepeat.cjs', str(mode)]))
    jobs.append((f'search-{mode}-fixture', ['node', 'build/test_search.cjs', f'--mode={mode}']))
    if source:
        jobs.append((f'search-{mode}-file', ['node', 'build/test_search.cjs', f'--mode={mode}', f'--file={source}']))
    for factor in (1,8):
        jobs.append((f'file-integrity-{mode}-{factor}', ['node', 'build/test_file_integrity.cjs', f'--mode={mode}', f'--cpu-factor={factor}']))
    for name, options in scenarios.items():
        jobs.append((f'basic-{mode}-{name}', ['node', 'build/test_basic_sessions.cjs', f'--mode={mode}', '--quiet', *options]))

def run(job):
    name, args = job
    result = subprocess.run(args, cwd=root, capture_output=True, text=True)
    (logs / f'{name}.log').write_text(result.stdout + result.stderr)
    return name, result.returncode

failed = []
with ThreadPoolExecutor(max_workers=4) as pool:
    futures = [pool.submit(run, job) for job in jobs]
    for future in as_completed(futures):
        name, code = future.result()
        print(('FAIL ' if code else 'PASS ') + name, flush=True)
        if code:
            failed.append(name)
if failed:
    raise SystemExit('Failed: ' + ', '.join(failed))
print(f'All {len(jobs)} suites passed.', flush=True)
