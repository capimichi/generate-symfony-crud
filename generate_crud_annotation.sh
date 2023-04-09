#!/bin/bash

# add usage parameter to show how to use this command
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: generate_crud.sh entity_name class_name url_name"
    echo "Example: generate_crud.sh access_token AccessToken access-token"
    exit 0
fi

# check if the parameter is provided
if [ -z "$1" ]; then
    echo "The entity name is required."
    echo "Usage: generate_crud.sh entity_name"
    echo "Example: generate_crud.sh access_token AccessToken access-token"
    exit 1
fi

# check if the parameter is provided
if [ -z "$2" ]; then
    echo "The entity name is required."
    echo "Usage: generate_crud.sh entity_name"
    echo "Example: generate_crud.sh access_token AccessToken access-token"
    exit 1
fi

# check if the parameter is provided
if [ -z "$3" ]; then
    echo "The entity name is required."
    echo "Usage: generate_crud.sh entity_name"
    echo "Example: generate_crud.sh access_token AccessToken access-token"
    exit 1
fi


entity_name=$1
class_name=$2
url_name=$3

name=${entity_name/_/ }
low_class_name="$(tr '[:upper:]' '[:lower:]' <<< ${class_name:0:1})${class_name:1}"


echo "<?php

namespace App\Controller;

use App\Entity\\${class_name};
use Nelmio\ApiDocBundle\Annotation\Model;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use OpenApi\Annotations as OA;

/**
 * Class ${class_name}Controller
 *
 * @package App\Controller
 *
 * @Route(\"/api\")
 */
class ${class_name}Controller extends AbstractController
{

    /**
     * @Route(\"/${url_name}s\", methods={\"GET\"}, name=\"api_${entity_name}s_list\")
     * @OA\Get(
     *    path=\"/api/${url_name}s\",
     *    tags={\"${class_name}s\"},
     *    summary=\"List ${name}s\",
     *    description=\"List ${name}s\",
     *    @OA\Response(
     *        response=200,
     *        description=\"Success\",
     *        @OA\JsonContent(
     *            type=\"array\",
     *            @OA\Items(ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:read\"}))
     *        ),
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref=\"#/components/responses/401\"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref=\"#/components/responses/404\"
     *    ),
     * )
     *
     * @return JsonResponse
     */
    public function listAction(): JsonResponse
    {
        // TODO: Implement listAction() method.
    }

    /**
     * @Route(\"/${url_name}s/{${low_class_name}Id}\", methods={\"GET\"}, name=\"api_${entity_name}s_view\")
     * @OA\Get(
     *    path=\"/api/${url_name}s/{${low_class_name}Id}\",
     *    tags={\"${class_name}s\"},
     *    summary=\"View a ${name}\",
     *    description=\"View a ${name}\",
     *    @OA\Parameter(
     *        ref=\"#/components/parameters/${low_class_name}Id\"
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description=\"Success\",
     *        @OA\JsonContent(
     *            type=\"object\",
     *            ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:read\"})
     *        ),
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref=\"#/components/responses/401\"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref=\"#/components/responses/404\"
     *    ),
     * )
     *
     * @param ${class_name} \$${low_class_name}
     * @return JsonResponse
     */
    public function viewAction(${class_name} \$${low_class_name}): JsonResponse
    {
        // TODO: Implement listAction() method.
    }

    /**
     * @Route(\"/${url_name}s\", methods={\"POST\"}, name=\"api_${entity_name}s_create\")
     * @OA\Post(
     *    path=\"/api/${url_name}s\",
     *    tags={\"${class_name}s\"},
     *    summary=\"Create a ${name}\",
     *    description=\"Create a ${name}\",
     *    @OA\RequestBody(
     *        description=\"${class_name} object that needs to be added to the store\",
     *        required=true,
     *        @OA\JsonContent(ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:write\"}))
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description=\"Success\",
     *        @OA\JsonContent(ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:read\"}))
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref=\"#/components/responses/400\"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref=\"#/components/responses/401\"
     *    )
     * )
     * @return JsonResponse
     */
    public function createAction(): JsonResponse
    {
        // TODO: Implement createAction() method.
    }

    /**
     * @Route(\"/${url_name}s/{${low_class_name}Id}\", methods={\"PATCH\"}, name=\"api_${entity_name}s_edit\")
     * @OA\Patch(
     *    path=\"/api/${url_name}s/{${low_class_name}Id}\",
     *    tags={\"${class_name}s\"},
     *    summary=\"Edit a ${name}\",
     *    description=\"Edit a ${name}\",
     *    @OA\Parameter(
     *        ref=\"#/components/parameters/${low_class_name}Id\"
     *    ),
     *    @OA\RequestBody(
     *        description=\"${class_name} object that needs to be edited to the store\",
     *        required=true,
     *        @OA\JsonContent(ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:write\"}))
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description=\"Success\",
     *        @OA\JsonContent(ref=@Model(type=App\Entity\\${class_name}::class, groups={\"${entity_name}:read\"}))
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref=\"#/components/responses/400\"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref=\"#/components/responses/401\"
     *    )
     * )
     * @param ${class_name} \$${low_class_name}
     * @return JsonResponse
     */
    public function editAction(${class_name} \$${low_class_name}): JsonResponse
    {
        // TODO: Implement editAction() method.
    }

    /**
     * @Route(\"/${url_name}s/{${low_class_name}Id}\", methods={\"DELETE\"}, name=\"api_${entity_name}s_delete\")
     * @OA\Delete(
     *    path=\"/api/${url_name}s/{${low_class_name}Id}\",
     *    tags={\"${class_name}s\"},
     *    summary=\"Delete a ${name}\",
     *    description=\"Delete a ${name}\",
     *    @OA\Parameter(
     *        ref=\"#/components/parameters/${low_class_name}Id\"
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description=\"Success\",
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref=\"#/components/responses/400\"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref=\"#/components/responses/401\"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref=\"#/components/responses/404\"
     *    )
     * )
     * @param ${class_name} \$${low_class_name}
     *
     * @return JsonResponse
     */
    public function deleteAction(${class_name} \$${low_class_name}): JsonResponse
    {
        // TODO: Implement deleteAction() method.
    }
}
"