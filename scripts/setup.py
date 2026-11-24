from pathlib import Path
import os
import tempfile


def copy_if_missing(source_name, target_name):
    source, target = Path(source_name), Path(target_name)
    root = Path.cwd().resolve()
    if not source.is_file() or not source.resolve().is_relative_to(root):
        raise SystemExit(f"Refusing missing or out-of-project template: {source_name}")
    if target.exists() or target.is_symlink():
        print(f"Preserved existing {target_name}")
        return
    fd, name = tempfile.mkstemp(prefix=f".{target_name}.", dir=".")
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(source.read_bytes())
            stream.flush()
            os.fsync(stream.fileno())
        os.link(name, target)
    except FileExistsError:
        print(f"Preserved existing {target_name}")
    finally:
        Path(name).unlink(missing_ok=True)


copy_if_missing("compose.example.yaml", "compose.yaml")
if Path(".env.example").is_file():
    copy_if_missing(".env.example", ".env")
