mod cli;
mod commands;

fn main() -> anyhow::Result<()> {
    let cli = cli::parse();
    commands::dispatch(cli)
}
