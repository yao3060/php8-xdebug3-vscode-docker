<?php

namespace App\Enums;

use MyCLabs\Enum\Enum;

/**
 * draft / published
 *
 * @method static self DRAFT()
 * @method static self PENDING()
 * @method static self PUBLISH()
 * @method static self TRASH()
 * @method static self PRIVATE()
 */
final class PostStatus extends Enum
{
    private const DRAFT = 'draft';
    private const PENDING = 'pending';
    private const PUBLISH = 'publish';
    private const TRASH = 'trash';
    private const PRIVATE = 'private';
}
