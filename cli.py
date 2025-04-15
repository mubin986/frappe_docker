#!/usr/bin/env python3
import click
import subprocess
import os
from pathlib import Path
import json

# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent.absolute()
CONFIG_FILE = SCRIPT_DIR / "config.json"

def load_config():
    """Load configuration from config.json"""
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE) as f:
            return json.load(f)
    return {
        "frappe_path": str(SCRIPT_DIR),
        "backup_paths": {
            "database": "",
            "public_files": "",
            "private_files": ""
        },
        "docker_compose_file": "pwd.yml"
    }

def save_config(config):
    """Save configuration to config.json"""
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

@click.group()
def cli():
    """Frappe Docker Management CLI"""
    pass

@cli.command()
@click.option('--frappe-path', help='Path to Frappe installation')
@click.option('--backup-database', help='Path to database backup file')
@click.option('--backup-public-files', help='Path to public files backup')
@click.option('--backup-private-files', help='Path to private files backup')
@click.option('--docker-compose-file', help='Docker compose file name')
def config(frappe_path, backup_database, backup_public_files, backup_private_files, docker_compose_file):
    """Configure paths for the CLI"""
    config = load_config()
    
    if frappe_path:
        config['frappe_path'] = frappe_path
    if backup_database:
        config['backup_paths']['database'] = backup_database
    if backup_public_files:
        config['backup_paths']['public_files'] = backup_public_files
    if backup_private_files:
        config['backup_paths']['private_files'] = backup_private_files
    if docker_compose_file:
        config['docker_compose_file'] = docker_compose_file
    
    save_config(config)
    click.echo("Configuration updated:")
    click.echo(json.dumps(config, indent=2))

@cli.command()
def build():
    """Build the Frappe Docker image"""
    config = load_config()
    click.echo("Building Frappe Docker image...")
    subprocess.run([f"{SCRIPT_DIR}/_build.sh"], shell=True)

@cli.command()
def run():
    """Start the Frappe Docker containers"""
    config = load_config()
    click.echo("Starting Frappe Docker containers...")
    subprocess.run([f"{SCRIPT_DIR}/_run.sh"], shell=True)

@cli.command()
def restart():
    """Restart the Frappe Docker containers"""
    config = load_config()
    click.echo("Restarting Frappe Docker containers...")
    subprocess.run([f"{SCRIPT_DIR}/_restart.sh"], shell=True)

@cli.command()
def remove():
    """Remove Frappe Docker containers, volumes, and networks"""
    config = load_config()
    if click.confirm("This will remove all containers, volumes, and networks. Are you sure?"):
        click.echo("Removing Frappe Docker environment...")
        subprocess.run([f"{SCRIPT_DIR}/_remove.sh"], shell=True)

@cli.command()
def migrate():
    """Run database migrations"""
    config = load_config()
    click.echo("Running database migrations...")
    subprocess.run([f"{SCRIPT_DIR}/_migration.sh"], shell=True)

@cli.command()
def restore_db():
    """Restore the database from backup"""
    config = load_config()
    if not config['backup_paths']['database']:
        click.echo("Error: Database backup path not configured. Use 'config --backup-database' to set it.")
        return
    click.echo("Restoring database...")
    subprocess.run([f"{SCRIPT_DIR}/_restore_db.sh"], shell=True)

@cli.command()
def restore_files():
    """Restore files from backup"""
    config = load_config()
    if not config['backup_paths']['public_files'] or not config['backup_paths']['private_files']:
        click.echo("Error: File backup paths not configured. Use 'config --backup-public-files' and 'config --backup-private-files' to set them.")
        return
    click.echo("Restoring files...")
    subprocess.run([f"{SCRIPT_DIR}/_restore_files.sh"], shell=True)

@cli.command()
def restore_lms():
    """Install and restore LMS app"""
    config = load_config()
    click.echo("Installing LMS app...")
    subprocess.run([f"{SCRIPT_DIR}/_restore_lms.sh"], shell=True)

@cli.command()
def restore_hrms():
    """Install and restore HRMS app"""
    config = load_config()
    click.echo("Installing HRMS app...")
    subprocess.run([f"{SCRIPT_DIR}/_restore_hrms.sh"], shell=True)

if __name__ == '__main__':
    cli() 