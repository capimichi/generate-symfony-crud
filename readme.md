# Generate Symfony Crud

This is a shell script to generate a Symfony CRUD controller.

## Usage

```bash
$ ./generate_crud_annotation.sh <entity_name> <class_name> <url_name>
```

## Example

```bash
$ ./generate_crud_annotation.sh access_token AccessToken access-token
```

## Result

```php
<?php

namespace App\Controller;

use App\Entity\AccessToken;
use App\Form\AccessTokenFormType;
use App\Repository\AccessTokenRepository;
use App\Service\FormService;
use Doctrine\ORM\EntityManagerInterface;
use JMS\Serializer\SerializationContext;
use JMS\Serializer\SerializerInterface;
use Nelmio\ApiDocBundle\Annotation\Model;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use OpenApi\Annotations as OA;

/**
 * Class AccessTokenController
 *
 * @package App\Controller
 *
 * @Route("/api")
 */
class AccessTokenController extends AbstractController
{

    /**
     * @Route("/access-tokens", methods={"GET"}, name="api_access_tokens_list")
     * @OA\Get(
     *    path="/api/access-tokens",
     *    tags={"AccessTokens"},
     *    summary="List access tokens",
     *    description="List access tokens",
     *    @OA\Parameter(ref="#/components/parameters/limit"),
     *    @OA\Parameter(ref="#/components/parameters/offset"),
     *    @OA\Response(
     *        response=200,
     *        description="Success",
     *        @OA\JsonContent(
     *            type="array",
     *            @OA\Items(ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:read"}))
     *        ),
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref="#/components/responses/401"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref="#/components/responses/404"
     *    ),
     * )
     *
     * @param Request             $request
     * @param AccessTokenRepository   $repository
     * @param SerializerInterface $serializer
     *
     * @return JsonResponse
     */
    public function listAction(Request $request, AccessTokenRepository $repository, SerializerInterface $serializer): JsonResponse
    {
        $accessTokens = $repository->findBy(
            [
                'user' => $this->getUser(),
            ],
            ['id' => 'DESC'],
            $request->query->getInt('limit', 10),
            $request->query->getInt('offset', 0)
        );
        $context = new SerializationContext();
        $context->setGroups(['access_token:read']);
        $data = json_decode($serializer->serialize($accessTokens, 'json', $context));
        return $this->json($data, 200);
    }

    /**
     * @Route("/access-tokens/{accessTokenId}", methods={"GET"}, name="api_access_tokens_view")
     * @OA\Get(
     *    path="/api/access-tokens/{accessTokenId}",
     *    tags={"AccessTokens"},
     *    summary="View a access token",
     *    description="View a access token",
     *    @OA\Parameter(
     *        ref="#/components/parameters/accessTokenId"
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description="Success",
     *        @OA\JsonContent(
     *            type="object",
     *            ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:read"})
     *        ),
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref="#/components/responses/401"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref="#/components/responses/404"
     *    ),
     * )
     *
     * @param int                 $accessTokenId
     * @param SerializerInterface $serializer
     *
     * @return JsonResponse
     */
    public function viewAction(int $accessTokenId, AccessTokenRepository $repository, SerializerInterface $serializer): JsonResponse
    {
        $accessToken = $repository->find($accessTokenId);
        if (!$accessToken || $accessToken->getUser() !== $this->getUser()) {
            return $this->json(null, 404);
        }

        $context = new SerializationContext();
        $context->setGroups(['access_token:read']);
        $data = json_decode($serializer->serialize($accessToken, 'json', $context), true);
        return $this->json($data);
    }

    /**
     * @Route("/access-tokens", methods={"POST"}, name="api_access_tokens_create")
     * @OA\Post(
     *    path="/api/access-tokens",
     *    tags={"AccessTokens"},
     *    summary="Create a access token",
     *    description="Create a access token",
     *    @OA\RequestBody(
     *        description="AccessToken object that needs to be added to the store",
     *        required=true,
     *        @OA\JsonContent(ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:write"}))
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description="Success",
     *        @OA\JsonContent(ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:read"}))
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref="#/components/responses/400"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref="#/components/responses/401"
     *    )
     * )
     * @param Request             $request
     * @param AccessTokenRepository   $repository
     * @param SerializerInterface $serializer
     *
     * @return JsonResponse
     */
    public function createAction(Request $request, AccessTokenRepository $repository, SerializerInterface $serializer): JsonResponse
    {
        $accessToken = new AccessToken();
        $form = $this->createForm(AccessTokenFormType::class, $accessToken);
        $form->submit($request->request->all());
        $accessToken->setUser($this->getUser());
        if (!$form->isSubmitted() || !$form->isValid()) {
            return $this->json([
                'errors' => FormService::getFormErrors($form),
            ], 400);
        }

        $context = new SerializationContext();
        $context->setGroups(['access_token:read']);
        try {
            $repository->save($accessToken, true);
        } catch (\Exception $e) {
            return $this->json([
                'errors' => [
                    $e->getMessage(),
                ],
            ], 400);
        }
        $data = json_decode($serializer->serialize($accessToken, 'json', $context));
        return $this->json($data);
    }

    /**
     * @Route("/access-tokens/{accessTokenId}", methods={"PATCH"}, name="api_access_tokens_edit")
     * @OA\Patch(
     *    path="/api/access-tokens/{accessTokenId}",
     *    tags={"AccessTokens"},
     *    summary="Edit a access token",
     *    description="Edit a access token",
     *    @OA\Parameter(
     *        ref="#/components/parameters/accessTokenId"
     *    ),
     *    @OA\RequestBody(
     *        description="AccessToken object that needs to be edited to the store",
     *        required=true,
     *        @OA\JsonContent(ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:write"}))
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description="Success",
     *        @OA\JsonContent(ref=@Model(type=App\Entity\AccessToken::class, groups={"access_token:read"}))
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref="#/components/responses/400"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref="#/components/responses/401"
     *    )
     * )
     * @param int                 $accessTokenId
     * @param Request             $request
     * @param AccessTokenRepository   $repository
     * @param SerializerInterface $serializer
     *
     * @return JsonResponse
     */
    public function editAction(int $accessTokenId, Request $request, AccessTokenRepository $repository, SerializerInterface $serializer): JsonResponse
    {
        $accessToken = $repository->find($accessTokenId);
        if (!$accessToken || $accessToken->getUser() !== $this->getUser()) {
            return $this->json(null, 404);
        }
        $form = $this->createForm(AccessTokenFormType::class, $accessToken);
        $form->submit($request->request->all());
        $accessToken->setUser($this->getUser());
        if (!$form->isSubmitted() || !$form->isValid()) {
            return $this->json([
                'errors' => FormService::getFormErrors($form),
            ], 400);
        }

        try {
            $repository->save($accessToken, true);
        } catch (\Exception $e) {
            return $this->json([
                'errors' => [
                    $e->getMessage(),
                ],
            ], 400);
        }
        $context = new SerializationContext();
        $context->setGroups(['access_token:read']);
        $data = json_decode($serializer->serialize($accessToken, 'json', $context), true);
        return $this->json($data);
    }

    /**
     * @Route("/access-tokens/{accessTokenId}", methods={"DELETE"}, name="api_access_tokens_delete")
     * @OA\Delete(
     *    path="/api/access-tokens/{accessTokenId}",
     *    tags={"AccessTokens"},
     *    summary="Delete a access token",
     *    description="Delete a access token",
     *    @OA\Parameter(
     *        ref="#/components/parameters/accessTokenId"
     *    ),
     *    @OA\Response(
     *        response=200,
     *        description="Success",
     *    ),
     *    @OA\Response(
     *        response=400,
     *        ref="#/components/responses/400"
     *    ),
     *    @OA\Response(
     *        response=401,
     *        ref="#/components/responses/401"
     *    ),
     *    @OA\Response(
     *        response=404,
     *        ref="#/components/responses/404"
     *    )
     * )
     * @param int               $accessTokenId
     * @param AccessTokenRepository $repository
     *
     * @return JsonResponse
     */
    public function deleteAction(int $accessTokenId, AccessTokenRepository $repository): JsonResponse
    {
        $accessToken = $repository->find($accessTokenId);
        if (!$accessToken || $accessToken->getUser() !== $this->getUser()) {
            return $this->json(null, 404);
        }
        $repository->remove($accessToken, true);
        return $this->json(null, 200);
    }
}
```

## Notes

The created controller is not yet functional.

It has some references to the `AccessToken` entity, but this entity does not yet exist.

It has references to the components defined in the file *nelmio_api_doc.yaml* to define parameters and responses.

Example

```yaml
components:
  parameters:
    domainId:
      name: domainId
      in: path
      description: The domain ID
      required: true
      schema:
        type: integer
        format: int64
    accessTokenId:
      name: accessTokenId
      in: path
      description: The domain ID
      required: true
      schema:
        type: integer
        format: int64
  responses:
    400:
      response: 400
      description: Bad request
    401:
      response: 401
      description: Unauthorized
    404:
      response: 404
      description: The resource was not found
```
