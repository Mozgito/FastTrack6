<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20220603103228 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE comment ALTER id DROP DEFAULT');
        $this->addSql('ALTER TABLE conference ADD slug VARCHAR(255)');
        $this->addSql('ALTER TABLE conference ALTER id DROP DEFAULT');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE conference DROP slug');
        $this->addSql('CREATE SEQUENCE conference_id_seq');
        $this->addSql('SELECT setval(\'conference_id_seq\', (SELECT MAX(id) FROM conference))');
        $this->addSql('ALTER TABLE conference ALTER id SET DEFAULT nextval(\'conference_id_seq\')');
        $this->addSql('CREATE SEQUENCE comment_id_seq');
        $this->addSql('SELECT setval(\'comment_id_seq\', (SELECT MAX(id) FROM comment))');
        $this->addSql('ALTER TABLE comment ALTER id SET DEFAULT nextval(\'comment_id_seq\')');
    }
}
