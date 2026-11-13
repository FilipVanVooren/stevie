"""Run the native search, keyboard/color and BASIC regression suites for R9."""
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
logs = root / 'build/autorepeat/validation-r9'
logs.mkdir(parents=True, exist_ok=True)
source = Path(sys.argv[1]) if len(sys.argv) > 1 else None
imported = Path(sys.argv[2]) if len(sys.argv) > 2 else None
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
    insert_cases = {
        'middle': [],
        'append': ['--at=1910'],
        'second-boundary': ['--records=4095', '--at=4095'],
        'callback-page': ['--records=3958', '--cpu-factor=8'],
        'newline-middle': ['--records=2047', '--newline'],
        'newline-tail': ['--records=4095', '--at=4095', '--newline'],
        'dirty-middle': ['--dirty'],
        'dirty-tail-fast': ['--dirty', '--at=1910', '--cpu-factor=8'],
    }
    if source and imported:
        for factor in (1,8):
            insert_cases[f'real-{factor}'] = [f'--base={source}', f'--import={imported}', f'--cpu-factor={factor}']
    for case, options in insert_cases.items():
        jobs.append((f'insert-{mode}-{case}', ['node','build/test_file_insert.cjs',f'--mode={mode}',*options]))
    delete_cases = {
        'middle-2048': ['--extra-lines=0','--deletions=1'],
        'past-2048': [],
        'head': ['--extra-lines=0','--delete-at=1','--deletions=1'],
        'tail': ['--extra-lines=0','--tail','--deletions=1'],
        'middle-4096': ['--records=3958','--extra-lines=0','--deletions=1'],
        'past-4096': ['--records=3958'],
    }
    if source and imported:
        for factor in (1,8):
            delete_cases[f'real-{factor}']=[f'--base={source}',f'--import={imported}','--at=84',f'--cpu-factor={factor}']
    for case, options in delete_cases.items():
        jobs.append((f'delete-{mode}-{case}',['node','build/test_file_delete.cjs',f'--mode={mode}',*options]))
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
